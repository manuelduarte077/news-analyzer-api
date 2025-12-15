package favorites

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/manuelduarte077/news-analyzer-api/internal/ports/favorites"
)

type repository struct {
	db *sql.DB
}

// NewRepository creates a new favorites repository instance.
func NewRepository(db *sql.DB) favorites.Repository {
	return &repository{db: db}
}

// SaveFavorite stores an analysis result as a favorite.
func (r *repository) SaveFavorite(ctx context.Context, analysisID int64, result string) (favorites.Entry, error) {
	// First, try to get existing favorite to preserve created_at
	var existing favorites.Entry
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
			return favorites.Entry{}, fmt.Errorf("failed to update favorite: %w", err)
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
		return favorites.Entry{}, fmt.Errorf("failed to save favorite: %w", err)
	}

	id, err := res.LastInsertId()
	if err != nil {
		return favorites.Entry{}, fmt.Errorf("failed to get favorite ID: %w", err)
	}

	// Retrieve the created favorite to get created_at
	var entry favorites.Entry
	row = r.db.QueryRowContext(ctx,
		"SELECT id, analysis_id, result, created_at FROM favorites WHERE id = ?",
		id,
	)
	if err := row.Scan(&entry.ID, &entry.AnalysisID, &entry.Result, &entry.CreatedAt); err != nil {
		return favorites.Entry{}, fmt.Errorf("failed to retrieve created favorite: %w", err)
	}

	return entry, nil
}

// GetFavorites retrieves paginated favorites.
func (r *repository) GetFavorites(ctx context.Context, limit, offset int) ([]favorites.Entry, int, error) {
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

	var entries []favorites.Entry
	for rows.Next() {
		var entry favorites.Entry
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
