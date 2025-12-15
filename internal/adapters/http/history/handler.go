package history

import (
	"log"
	"strconv"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/ports/history"
)

// Handler handles HTTP requests for history operations.
type Handler struct {
	service history.Service
}

// NewHandler creates a new history handler instance.
func NewHandler(service history.Service) *Handler {
	return &Handler{service: service}
}

// GetHistory handles the retrieval of analysis history.
// It accepts optional query parameters: page (default: 1) and page_size (default: 10, max: 100).
func (h *Handler) GetHistory() fiber.Handler {
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

		result, err := h.service.GetHistory(c.Context(), page, pageSize)
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
