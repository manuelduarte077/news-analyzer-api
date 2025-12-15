package favorites

import "context"

// Repository defines the interface for favorites persistence operations.
type Repository interface {
	// SaveFavorite stores an analysis result as a favorite.
	// Returns the created favorite entry and any error encountered.
	SaveFavorite(ctx context.Context, analysisID int64, result string) (Entry, error)

	// GetFavorites retrieves paginated favorites.
	// Returns entries, total count, and any error encountered.
	GetFavorites(ctx context.Context, limit, offset int) ([]Entry, int, error)

	// DeleteFavorite removes a favorite by its ID.
	// Returns a boolean indicating if the favorite was found and deleted, and any error encountered.
	DeleteFavorite(ctx context.Context, id int64) (bool, error)
}

// Entry represents a single favorite entry from the database.
type Entry struct {
	ID         int64
	AnalysisID int64
	Result     string
	CreatedAt  string
}
