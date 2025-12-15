package history

import (
	"context"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/history"
)

// Service defines the interface for history operations.
type Service interface {
	// GetHistory retrieves paginated analysis history.
	// Page and pageSize are validated and normalized (page >= 1, pageSize 1-100).
	GetHistory(ctx context.Context, page, pageSize int) (history.Response, error)
}
