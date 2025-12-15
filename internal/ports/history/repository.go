package history

import "context"

// Repository defines the interface for history persistence operations.
type Repository interface {
	// GetHistory retrieves paginated analysis history.
	// Returns entries, total count, and any error encountered.
	GetHistory(ctx context.Context, limit, offset int) ([]Entry, int, error)
}

// Entry represents a single history entry from the database.
type Entry struct {
	ID        int64
	Result    string
	CreatedAt string
}

