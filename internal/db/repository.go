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

	// FindByID retrieves an analysis result by its ID.
	// Returns the result and a boolean indicating if it was found.
	FindByID(ctx context.Context, id int64) (HistoryEntry, bool)

	// SaveFavorite stores an analysis result as a favorite.
	// Returns the created favorite entry and any error encountered.
	SaveFavorite(ctx context.Context, analysisID int64, result string) (FavoriteEntry, error)

	// GetFavorites retrieves paginated favorites.
	// Returns entries, total count, and any error encountered.
	GetFavorites(ctx context.Context, limit, offset int) ([]FavoriteEntry, int, error)

	// DeleteFavorite removes a favorite by its ID.
	// Returns a boolean indicating if the favorite was found and deleted, and any error encountered.
	DeleteFavorite(ctx context.Context, id int64) (bool, error)
}

// HistoryEntry represents a single history entry from the database.
type HistoryEntry struct {
	ID        int64
	Result    string
	CreatedAt string
}

// FavoriteEntry represents a single favorite entry from the database.
type FavoriteEntry struct {
	ID         int64
	AnalysisID int64
	Result     string
	CreatedAt  string
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

// FindByID retrieves an analysis result by its ID.
func (r *repository) FindByID(ctx context.Context, id int64) (HistoryEntry, bool) {
	row := r.db.QueryRowContext(ctx,
		"SELECT id, result, created_at FROM analysis WHERE id = ?",
		id,
	)

	var entry HistoryEntry
	err := row.Scan(&entry.ID, &entry.Result, &entry.CreatedAt)
	return entry, err == nil
}

// SaveFavorite stores an analysis result as a favorite.
func (r *repository) SaveFavorite(ctx context.Context, analysisID int64, result string) (FavoriteEntry, error) {
	// First, try to get existing favorite to preserve created_at
	var existing FavoriteEntry
	row := r.db.QueryRowContext(ctx,
		"SELECT id, analysis_id, result, created_at FROM favorites WHERE analysis_id = ?",
		analysisID,
	)
	err := row.Scan(&existing.ID, &existing.AnalysisID, &existing.Result, &existing.CreatedAt)

	if err == nil {
		// Update existing favorite
		_, err := r.db.ExecContext(ctx,
			"UPDATE favorites SET result = ? WHERE analysis_id = ?",
			result, analysisID,
		)
		if err != nil {
			return FavoriteEntry{}, fmt.Errorf("failed to update favorite: %w", err)
		}
		existing.Result = result
		return existing, nil
	}

	// Insert new favorite
	res, err := r.db.ExecContext(ctx,
		"INSERT INTO favorites (analysis_id, result) VALUES (?, ?)",
		analysisID, result,
	)
	if err != nil {
		return FavoriteEntry{}, fmt.Errorf("failed to save favorite: %w", err)
	}

	id, err := res.LastInsertId()
	if err != nil {
		return FavoriteEntry{}, fmt.Errorf("failed to get favorite ID: %w", err)
	}

	// Retrieve the created favorite to get created_at
	var entry FavoriteEntry
	row = r.db.QueryRowContext(ctx,
		"SELECT id, analysis_id, result, created_at FROM favorites WHERE id = ?",
		id,
	)
	if err := row.Scan(&entry.ID, &entry.AnalysisID, &entry.Result, &entry.CreatedAt); err != nil {
		return FavoriteEntry{}, fmt.Errorf("failed to retrieve created favorite: %w", err)
	}

	return entry, nil
}

// GetFavorites retrieves paginated favorites.
func (r *repository) GetFavorites(ctx context.Context, limit, offset int) ([]FavoriteEntry, int, error) {
	var total int
	err := r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM favorites").Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count favorites: %w", err)
	}

	rows, err := r.db.QueryContext(ctx,
		"SELECT id, analysis_id, result, created_at FROM favorites ORDER BY created_at DESC LIMIT ? OFFSET ?",
		limit, offset,
	)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query favorites: %w", err)
	}
	defer rows.Close()

	var entries []FavoriteEntry
	for rows.Next() {
		var entry FavoriteEntry
		if err := rows.Scan(&entry.ID, &entry.AnalysisID, &entry.Result, &entry.CreatedAt); err != nil {
			return nil, 0, fmt.Errorf("failed to scan favorite entry: %w", err)
		}
		entries = append(entries, entry)
	}

	if err := rows.Err(); err != nil {
		return nil, 0, fmt.Errorf("error iterating favorite rows: %w", err)
	}

	return entries, total, nil
}

// DeleteFavorite removes a favorite by its ID.
func (r *repository) DeleteFavorite(ctx context.Context, id int64) (bool, error) {
	res, err := r.db.ExecContext(ctx,
		"DELETE FROM favorites WHERE id = ?",
		id,
	)
	if err != nil {
		return false, fmt.Errorf("failed to delete favorite: %w", err)
	}

	rowsAffected, err := res.RowsAffected()
	if err != nil {
		return false, fmt.Errorf("failed to get rows affected: %w", err)
	}

	return rowsAffected > 0, nil
}
