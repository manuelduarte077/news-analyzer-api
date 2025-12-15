package history

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/manuelduarte077/news-analyzer-api/internal/ports/history"
)

type repository struct {
	db *sql.DB
}

// NewRepository creates a new history repository instance.
func NewRepository(db *sql.DB) history.Repository {
	return &repository{db: db}
}

// GetHistory retrieves paginated analysis history.
func (r *repository) GetHistory(ctx context.Context, limit, offset int) ([]history.Entry, int, error) {
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

	var entries []history.Entry
	for rows.Next() {
		var entry history.Entry
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

