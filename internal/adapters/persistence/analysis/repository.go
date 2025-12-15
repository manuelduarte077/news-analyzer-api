package analysis

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/manuelduarte077/news-analyzer-api/internal/ports/analysis"
)

type repository struct {
	db *sql.DB
}

// NewRepository creates a new analysis repository instance.
func NewRepository(db *sql.DB) analysis.Repository {
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

// FindByID retrieves an analysis result by its ID.
func (r *repository) FindByID(ctx context.Context, id int64) (analysis.Entry, bool) {
	row := r.db.QueryRowContext(ctx,
		"SELECT id, result, created_at FROM analysis WHERE id = ?",
		id,
	)

	var entry analysis.Entry
	err := row.Scan(&entry.ID, &entry.Result, &entry.CreatedAt)
	return entry, err == nil
}

