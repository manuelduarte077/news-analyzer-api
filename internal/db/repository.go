package db

import (
	"context"
	"database/sql"
	"fmt"
)

// Repository defines the interface for data persistence operations.
// It provides methods for storing and retrieving analysis results.
type Repository interface {
	// Save stores an analysis result in the database using the provided hash as key.
	Save(ctx context.Context, hash string, result string) error

	// FindByHash retrieves an analysis result by its hash.
	// Returns the result and a boolean indicating if it was found.
	FindByHash(ctx context.Context, hash string) (string, bool)

	// GetHistory retrieves paginated analysis history.
	// Returns entries, total count, and any error encountered.
	GetHistory(ctx context.Context, limit, offset int) ([]HistoryEntry, int, error)
}

// HistoryEntry represents a single history entry from the database.
type HistoryEntry struct {
	ID        int64
	Result    string
	CreatedAt string
}

type repository struct {
	db *sql.DB
}

// NewRepository creates a new repository instance.
func NewRepository(db *sql.DB) Repository {
	return &repository{db: db}
}

// Save stores an analysis result in the database.
func (r *repository) Save(ctx context.Context, hash string, result string) error {
	_, err := r.db.ExecContext(ctx,
		"INSERT OR IGNORE INTO analysis (input_hash, result) VALUES (?, ?)",
		hash, result,
	)
	if err != nil {
		return fmt.Errorf("failed to save analysis result: %w", err)
	}
	return nil
}

// FindByHash retrieves an analysis result by its hash.
func (r *repository) FindByHash(ctx context.Context, hash string) (string, bool) {
	row := r.db.QueryRowContext(ctx,
		"SELECT result FROM analysis WHERE input_hash = ?",
		hash,
	)

	var result string
	err := row.Scan(&result)
	return result, err == nil
}

// GetHistory retrieves paginated analysis history.
func (r *repository) GetHistory(ctx context.Context, limit, offset int) ([]HistoryEntry, int, error) {
	var total int
	err := r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM analysis").Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count history entries: %w", err)
	}

	rows, err := r.db.QueryContext(ctx,
		"SELECT id, result, created_at FROM analysis ORDER BY created_at DESC LIMIT ? OFFSET ?",
		limit, offset,
	)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query history entries: %w", err)
	}
	defer rows.Close()

	var entries []HistoryEntry
	for rows.Next() {
		var entry HistoryEntry
		if err := rows.Scan(&entry.ID, &entry.Result, &entry.CreatedAt); err != nil {
			return nil, 0, fmt.Errorf("failed to scan history entry: %w", err)
		}
		entries = append(entries, entry)
	}

	if err := rows.Err(); err != nil {
		return nil, 0, fmt.Errorf("error iterating history rows: %w", err)
	}

	return entries, total, nil
}
