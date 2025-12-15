package favorites

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/analysis"
	"github.com/manuelduarte077/news-analyzer-api/internal/domain/favorites"
	analysisPort "github.com/manuelduarte077/news-analyzer-api/internal/ports/analysis"
	favoritesPort "github.com/manuelduarte077/news-analyzer-api/internal/ports/favorites"
)

type service struct {
	analysisRepo analysisPort.Repository
	favRepo      favoritesPort.Repository
}

// NewService creates a new favorites service instance.
func NewService(analysisRepo analysisPort.Repository, favRepo favoritesPort.Repository) favoritesPort.Service {
	return &service{
		analysisRepo: analysisRepo,
		favRepo:      favRepo,
	}
}

// SaveFavorite stores an analysis result as a favorite.
func (s *service) SaveFavorite(ctx context.Context, analysisID int64) (favorites.Favorite, error) {
	// Get the analysis result by ID
	entry, found := s.analysisRepo.FindByID(ctx, analysisID)
	if !found {
		return favorites.Favorite{}, fmt.Errorf("analysis with ID %d not found", analysisID)
	}

	// Save as favorite
	favEntry, err := s.favRepo.SaveFavorite(ctx, analysisID, entry.Result)
	if err != nil {
		return favorites.Favorite{}, fmt.Errorf("failed to save favorite: %w", err)
	}

	// Parse the result to return the full favorite object
	var result analysis.Result
	if err := json.Unmarshal([]byte(favEntry.Result), &result); err != nil {
		return favorites.Favorite{}, fmt.Errorf("failed to parse analysis result: %w", err)
	}

	return favorites.Favorite{
		ID:         favEntry.ID,
		AnalysisID: favEntry.AnalysisID,
		Result:     result,
		CreatedAt:  favEntry.CreatedAt,
	}, nil
}

// GetFavorites retrieves paginated favorites.
func (s *service) GetFavorites(ctx context.Context, page, pageSize int) (favorites.ListResponse, error) {
	if page < 1 {
		page = 1
	}
	if pageSize < 1 {
		pageSize = 10
	}
	if pageSize > 100 {
		pageSize = 100
	}

	offset := (page - 1) * pageSize
	entries, total, err := s.favRepo.GetFavorites(ctx, pageSize, offset)
	if err != nil {
		return favorites.ListResponse{}, fmt.Errorf("failed to retrieve favorites: %w", err)
	}

	items := make([]favorites.Favorite, 0, len(entries))
	for _, entry := range entries {
		var result analysis.Result
		if err := json.Unmarshal([]byte(entry.Result), &result); err != nil {
			continue
		}
		items = append(items, favorites.Favorite{
			ID:         entry.ID,
			AnalysisID: entry.AnalysisID,
			Result:     result,
			CreatedAt:  entry.CreatedAt,
		})
	}

	totalPages := (total + pageSize - 1) / pageSize
	if totalPages == 0 {
		totalPages = 1
	}

	return favorites.ListResponse{
		Items:      items,
		Total:      total,
		Page:       page,
		PageSize:   pageSize,
		TotalPages: totalPages,
	}, nil
}

// DeleteFavorite removes a favorite by its ID.
func (s *service) DeleteFavorite(ctx context.Context, id int64) error {
	found, err := s.favRepo.DeleteFavorite(ctx, id)
	if err != nil {
		return fmt.Errorf("failed to delete favorite: %w", err)
	}

	if !found {
		return fmt.Errorf("favorite with ID %d not found", id)
	}

	return nil
}

