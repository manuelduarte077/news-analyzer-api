package history

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/analysis"
	"github.com/manuelduarte077/news-analyzer-api/internal/domain/history"
	historyPort "github.com/manuelduarte077/news-analyzer-api/internal/ports/history"
)

type service struct {
	repo historyPort.Repository
}

// NewService creates a new history service instance.
func NewService(repo historyPort.Repository) historyPort.Service {
	return &service{repo: repo}
}

// GetHistory retrieves paginated analysis history.
func (s *service) GetHistory(ctx context.Context, page, pageSize int) (history.Response, error) {
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
		return history.Response{}, fmt.Errorf("failed to retrieve history: %w", err)
	}

	items := make([]history.Entry, 0, len(entries))
	for _, entry := range entries {
		var result analysis.Result
		if err := json.Unmarshal([]byte(entry.Result), &result); err != nil {
			continue
		}
		items = append(items, history.Entry{
			ID:        entry.ID,
			Result:    result,
			CreatedAt: entry.CreatedAt,
		})
	}

	totalPages := (total + pageSize - 1) / pageSize
	if totalPages == 0 {
		totalPages = 1
	}

	return history.Response{
		Items:      items,
		Total:      total,
		Page:       page,
		PageSize:   pageSize,
		TotalPages: totalPages,
	}, nil
}

