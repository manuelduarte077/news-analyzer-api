package analysis

import "context"

// Repository defines the interface for analysis persistence operations.
type Repository interface {
	// Save stores an analysis result in the database using the provided hash as key.
	Save(ctx context.Context, hash string, result string) error

	// FindByHash retrieves an analysis result by its hash.
	// Returns the result and a boolean indicating if it was found.
	FindByHash(ctx context.Context, hash string) (string, bool)

	// FindByID retrieves an analysis result by its ID.
	// Returns the result and a boolean indicating if it was found.
	FindByID(ctx context.Context, id int64) (Entry, bool)
}

// Entry represents a single analysis entry from the database.
type Entry struct {
	ID        int64
	Result    string
	CreatedAt string
}
