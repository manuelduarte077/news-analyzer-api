package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"

	"github.com/manuelduarte077/news-analyzer-api/internal/analyzer"
	"github.com/manuelduarte077/news-analyzer-api/internal/db"
	"github.com/manuelduarte077/news-analyzer-api/internal/extractor"
	"github.com/manuelduarte077/news-analyzer-api/internal/models"
)

// Service defines the interface for the analysis service.
// It provides methods for analyzing news articles and retrieving analysis history.
type Service interface {
	// AnalyzeNews processes a news article analysis request.
	// It accepts either a URL or raw text content for analysis.
	AnalyzeNews(ctx context.Context, url, text string) (models.AnalysisResult, error)

	// GetHistory retrieves paginated analysis history.
	// Page and pageSize are validated and normalized (page >= 1, pageSize 1-100).
	GetHistory(ctx context.Context, page, pageSize int) (models.HistoryResponse, error)

	// SaveFavorite stores an analysis result as a favorite.
	// Returns the created favorite and any error encountered.
	SaveFavorite(ctx context.Context, analysisID int64) (models.Favorite, error)

	// GetFavorites retrieves paginated favorites.
	// Page and pageSize are validated and normalized (page >= 1, pageSize 1-100).
	GetFavorites(ctx context.Context, page, pageSize int) (models.FavoriteListResponse, error)

	// DeleteFavorite removes a favorite by its ID.
	// Returns any error encountered.
	DeleteFavorite(ctx context.Context, id int64) error
}

type service struct {
	analyzer  analyzer.Analyzer
	extractor extractor.Extractor
	repo      db.Repository
}

// NewService creates a new analysis service instance.
func NewService(analyzer analyzer.Analyzer, extractor extractor.Extractor, repo db.Repository) Service {
	return &service{
		analyzer:  analyzer,
		extractor: extractor,
		repo:      repo,
	}
}

// AnalyzeNews processes a news article analysis request.
func (s *service) AnalyzeNews(ctx context.Context, url, text string) (models.AnalysisResult, error) {
	if url == "" && text == "" {
		return models.AnalysisResult{}, fmt.Errorf("either url or text must be provided")
	}

	var content string
	var err error

	if url != "" {
		content, err = s.extractor.FromURL(ctx, url)
		if err != nil {
			return models.AnalysisResult{}, fmt.Errorf("failed to extract content from URL: %w", err)
		}
	} else {
		content = text
	}

	if content == "" {
		return models.AnalysisResult{}, fmt.Errorf("no content available for analysis")
	}

	hash := computeHash(content)

	if cached, ok := s.repo.FindByHash(ctx, hash); ok {
		var result models.AnalysisResult
		if err := json.Unmarshal([]byte(cached), &result); err == nil {
			return result, nil
		}
	}

	result, err := s.analyzer.Analyze(ctx, content)
	if err != nil {
		return models.AnalysisResult{}, fmt.Errorf("failed to analyze content: %w", err)
	}

	raw, err := json.Marshal(result)
	if err != nil {
		return models.AnalysisResult{}, fmt.Errorf("failed to serialize result: %w", err)
	}

	if err := s.repo.Save(ctx, hash, string(raw)); err != nil {
		return models.AnalysisResult{}, fmt.Errorf("failed to save result: %w", err)
	}

	return result, nil
}

// GetHistory retrieves paginated analysis history.
func (s *service) GetHistory(ctx context.Context, page, pageSize int) (models.HistoryResponse, error) {
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
	entries, total, err := s.repo.GetHistory(ctx, pageSize, offset)
	if err != nil {
		return models.HistoryResponse{}, fmt.Errorf("failed to retrieve history: %w", err)
	}

	items := make([]models.AnalysisHistory, 0, len(entries))
	for _, entry := range entries {
		var result models.AnalysisResult
		if err := json.Unmarshal([]byte(entry.Result), &result); err != nil {
			continue
		}
		items = append(items, models.AnalysisHistory{
			ID:        entry.ID,
			Result:    result,
			CreatedAt: entry.CreatedAt,
		})
	}

	totalPages := (total + pageSize - 1) / pageSize
	if totalPages == 0 {
		totalPages = 1
	}

	return models.HistoryResponse{
		Items:      items,
		Total:      total,
		Page:       page,
		PageSize:   pageSize,
		TotalPages: totalPages,
	}, nil
}

// SaveFavorite stores an analysis result as a favorite.
func (s *service) SaveFavorite(ctx context.Context, analysisID int64) (models.Favorite, error) {
	// Get the analysis result by ID
	entry, found := s.repo.FindByID(ctx, analysisID)
	if !found {
		return models.Favorite{}, fmt.Errorf("analysis with ID %d not found", analysisID)
	}

	// Save as favorite
	favEntry, err := s.repo.SaveFavorite(ctx, analysisID, entry.Result)
	if err != nil {
		return models.Favorite{}, fmt.Errorf("failed to save favorite: %w", err)
	}

	// Parse the result to return the full favorite object
	var result models.AnalysisResult
	if err := json.Unmarshal([]byte(favEntry.Result), &result); err != nil {
		return models.Favorite{}, fmt.Errorf("failed to parse analysis result: %w", err)
	}

	return models.Favorite{
		ID:         favEntry.ID,
		AnalysisID: favEntry.AnalysisID,
		Result:     result,
		CreatedAt:  favEntry.CreatedAt,
	}, nil
}

// GetFavorites retrieves paginated favorites.
func (s *service) GetFavorites(ctx context.Context, page, pageSize int) (models.FavoriteListResponse, error) {
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
	entries, total, err := s.repo.GetFavorites(ctx, pageSize, offset)
	if err != nil {
		return models.FavoriteListResponse{}, fmt.Errorf("failed to retrieve favorites: %w", err)
	}

	items := make([]models.Favorite, 0, len(entries))
	for _, entry := range entries {
		var result models.AnalysisResult
		if err := json.Unmarshal([]byte(entry.Result), &result); err != nil {
			continue
		}
		items = append(items, models.Favorite{
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

	return models.FavoriteListResponse{
		Items:      items,
		Total:      total,
		Page:       page,
		PageSize:   pageSize,
		TotalPages: totalPages,
	}, nil
}

// DeleteFavorite removes a favorite by its ID.
func (s *service) DeleteFavorite(ctx context.Context, id int64) error {
	found, err := s.repo.DeleteFavorite(ctx, id)
	if err != nil {
		return fmt.Errorf("failed to delete favorite: %w", err)
	}

	if !found {
		return fmt.Errorf("favorite with ID %d not found", id)
	}

	return nil
}

func computeHash(text string) string {
	hashBytes := sha256.Sum256([]byte(text))
	return hex.EncodeToString(hashBytes[:])
}
