package analysis

import (
	"log"
	"net/url"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/ports/analysis"
)

// Request represents the analysis request payload.
type Request struct {
	URL  string `json:"url"`
	Text string `json:"text"`
}

// Handler handles HTTP requests for analysis operations.
type Handler struct {
	service analysis.Service
}

// NewHandler creates a new analysis handler instance.
func NewHandler(service analysis.Service) *Handler {
	return &Handler{service: service}
}

// AnalyzeNews handles the analysis of news articles.
// It accepts a JSON payload with either a URL or raw text.
func (h *Handler) AnalyzeNews() fiber.Handler {
	return func(c *fiber.Ctx) error {
		var req Request
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error":   "Invalid JSON payload",
				"details": err.Error(),
			})
		}

		// Validate input
		if req.URL != "" {
			if err := validateURL(req.URL); err != nil {
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
					"error":   "Invalid URL",
					"details": err.Error(),
				})
			}
		}

		if req.Text != "" {
			req.Text = strings.TrimSpace(req.Text)
			if len(req.Text) > 100000 {
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
					"error": "Text content too large (max 100,000 characters)",
				})
			}
		}

		result, err := h.service.AnalyzeNews(c.Context(), req.URL, req.Text)
		if err != nil {
			log.Printf("Error analyzing news: %v", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "Failed to analyze news",
				"details": err.Error(),
			})
		}

		return c.JSON(result)
	}
}

// validateURL validates that the provided string is a valid URL.
func validateURL(urlStr string) error {
	if urlStr == "" {
		return nil
	}
	parsed, err := url.Parse(urlStr)
	if err != nil {
		return err
	}
	if parsed.Scheme != "http" && parsed.Scheme != "https" {
		return fiber.NewError(fiber.StatusBadRequest, "URL must use http or https scheme")
	}
	if parsed.Host == "" {
		return fiber.NewError(fiber.StatusBadRequest, "URL must have a valid host")
	}
	return nil
}
