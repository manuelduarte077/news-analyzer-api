package handlers

import (
	"log"
	"strconv"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/service"
)

// GetHistory handles the retrieval of analysis history.
func GetHistory(svc service.Service) fiber.Handler {
	return func(c *fiber.Ctx) error {
		page, _ := strconv.Atoi(c.Query("page", "1"))
		pageSize, _ := strconv.Atoi(c.Query("page_size", "10"))

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
