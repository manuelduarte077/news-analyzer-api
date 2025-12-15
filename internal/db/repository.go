package db

import (
	"context"
	"database/sql"
)

// Repository defines the interface for data persistence operations.
type Repository interface {
	Save(ctx context.Context, hash string, result string) error
	FindByHash(ctx context.Context, hash string) (string, bool)
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
