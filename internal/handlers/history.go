package handlers

import (
	"log"
	"strconv"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/service"
)

// GetHistory handles the retrieval of analysis history.
// It accepts optional query parameters: page (default: 1) and page_size (default: 10, max: 100).
func GetHistory(svc service.Service) fiber.Handler {
	return func(c *fiber.Ctx) error {
		pageStr := c.Query("page", "1")
		pageSizeStr := c.Query("page_size", "10")

		page, err := strconv.Atoi(pageStr)
		if err != nil || page < 1 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Invalid page parameter (must be a positive integer)",
			})
		}

		pageSize, err := strconv.Atoi(pageSizeStr)
		if err != nil || pageSize < 1 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Invalid page_size parameter (must be a positive integer)",
			})
		}

		result, err := svc.GetHistory(c.Context(), page, pageSize)
		if err != nil {
			log.Printf("Error retrieving history: %v", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "Failed to retrieve history",
				"details": err.Error(),
			})
		}

		return c.JSON(result)
	}
}
