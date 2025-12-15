package handlers

import (
	"log"
	"strconv"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/service"
)

// SaveFavoriteRequest represents the request payload for saving a favorite.
type SaveFavoriteRequest struct {
	AnalysisID int64 `json:"analysis_id"`
}

// SaveFavorite handles saving an analysis result as a favorite.
// It accepts a JSON payload with analysis_id.
func SaveFavorite(svc service.Service) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var req SaveFavoriteRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error":   "Invalid JSON payload",
				"details": err.Error(),
			})
		}

		if req.AnalysisID <= 0 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "analysis_id must be a positive integer",
			})
		}

		favorite, err := svc.SaveFavorite(c.Context(), req.AnalysisID)
		if err != nil {
			log.Printf("Error saving favorite: %v", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "Failed to save favorite",
				"details": err.Error(),
			})
		}

		return c.Status(fiber.StatusCreated).JSON(favorite)
	}
}

// GetFavorites handles the retrieval of favorites.
// It accepts optional query parameters: page (default: 1) and page_size (default: 10, max: 100).
func GetFavorites(svc service.Service) fiber.Handler {
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

		result, err := svc.GetFavorites(c.Context(), page, pageSize)
		if err != nil {
			log.Printf("Error retrieving favorites: %v", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "Failed to retrieve favorites",
				"details": err.Error(),
			})
		}

		return c.JSON(result)
	}
}

// DeleteFavorite handles the deletion of a favorite.
// It accepts the favorite ID as a URL parameter.
func DeleteFavorite(svc service.Service) fiber.Handler {
	return func(c *fiber.Ctx) error {
		idStr := c.Params("id")
		if idStr == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Favorite ID is required",
			})
		}

		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil || id <= 0 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Invalid favorite ID (must be a positive integer)",
			})
		}

		if err := svc.DeleteFavorite(c.Context(), id); err != nil {
			log.Printf("Error deleting favorite: %v", err)
			statusCode := fiber.StatusInternalServerError
			if strings.Contains(err.Error(), "not found") {
				statusCode = fiber.StatusNotFound
			}
			return c.Status(statusCode).JSON(fiber.Map{
				"error":   "Failed to delete favorite",
				"details": err.Error(),
			})
		}

		return c.Status(fiber.StatusNoContent).Send(nil)
	}
}

