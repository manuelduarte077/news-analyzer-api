package favorites

import (
	"context"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/favorites"
)

// Service defines the interface for favorites operations.
type Service interface {
	// SaveFavorite stores an analysis result as a favorite.
	// Returns the created favorite and any error encountered.
	SaveFavorite(ctx context.Context, analysisID int64) (favorites.Favorite, error)

	// GetFavorites retrieves paginated favorites.
	// Page and pageSize are validated and normalized (page >= 1, pageSize 1-100).
	GetFavorites(ctx context.Context, page, pageSize int) (favorites.ListResponse, error)

	// DeleteFavorite removes a favorite by its ID.
	// Returns any error encountered.
	DeleteFavorite(ctx context.Context, id int64) error
}

