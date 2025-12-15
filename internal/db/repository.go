package db

import (
	"context"
	"database/sql"
)

// Repository defines the interface for data persistence operations.
type Repository interface {
	Save(ctx context.Context, hash string, result string) error
	FindByHash(ctx context.Context, hash string) (string, bool)
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
		return err
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
		return nil, 0, err
	}

	rows, err := r.db.QueryContext(ctx,
		"SELECT id, result, created_at FROM analysis ORDER BY created_at DESC LIMIT ? OFFSET ?",
		limit, offset,
	)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var entries []HistoryEntry
	for rows.Next() {
		var entry HistoryEntry
		if err := rows.Scan(&entry.ID, &entry.Result, &entry.CreatedAt); err != nil {
			return nil, 0, err
		}
		entries = append(entries, entry)
	}

	if err := rows.Err(); err != nil {
		return nil, 0, err
	}

	return entries, total, nil
}
