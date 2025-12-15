package handlers

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/service"
)

type Request struct {
	URL  string `json:"url"`
	Text string `json:"text"`
}

// AnalyzeNews handles the analysis of news articles.
func AnalyzeNews(svc service.Service) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var req Request
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error":   "Invalid JSON payload",
				"details": err.Error(),
			})
		}

		result, err := svc.AnalyzeNews(c.Context(), req.URL, req.Text)
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
