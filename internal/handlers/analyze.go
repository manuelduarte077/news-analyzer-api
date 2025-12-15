package handlers

import (
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
	"encoding/json"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/analyzer"
	"github.com/manuelduarte077/news-analyzer-api/internal/db"
	"github.com/manuelduarte077/news-analyzer-api/internal/extractor"
)

type Request struct {
	URL  string `json:"url"`
	Text string `json:"text"`
}

// AnalyzeNews handles the analysis of news articles.
//
// It accepts a JSON payload with either a URL or raw text.
// If a URL is provided, it extracts the text content from the web page.
// It then checks if the analysis result is cached in the database using
// a hash of the input text. If cached, it returns the cached result.
// Otherwise, it performs the analysis using the analyzer package,
// stores the result in the database, and returns the analysis result.
//
// Parameters:
//   - database: A pointer to the SQL database connection
//
// Returns:
//   - fiber.Handler: The HTTP handler function for analyzing news articles
func AnalyzeNews(database *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var req Request
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error":   "Invalid JSON payload",
				"details": err.Error(),
			})
		}

		// Validate that at least one field is provided
		if req.URL == "" && req.Text == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Either 'url' or 'text' field must be provided",
			})
		}

		var text string
		if req.URL != "" {
			t, err := extractor.FromURL(req.URL)
			if err != nil {
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
					"error":   "Failed to extract content from URL",
					"details": err.Error(),
				})
			}
			text = t
		} else {
			text = req.Text
		}

		if text == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "No text content available for analysis",
			})
		}

		hashBytes := sha256.Sum256([]byte(text))
		hash := hex.EncodeToString(hashBytes[:])

		if cached, ok := db.FindByHash(database, hash); ok {
			var result any
			if err := json.Unmarshal([]byte(cached), &result); err == nil {
				return c.JSON(result)
			}
		}

		result, err := analyzer.Analyze(text)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "Failed to analyze text",
				"details": err.Error(),
			})
		}

		raw, err := json.Marshal(result)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "Failed to serialize result",
				"details": err.Error(),
			})
		}

		if err := db.Save(database, hash, string(raw)); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "Failed to save result",
				"details": err.Error(),
			})
		}

		return c.JSON(result)
	}
}
