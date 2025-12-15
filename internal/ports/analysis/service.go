package analysis

import (
	"context"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/analysis"
)

// Service defines the interface for analysis operations.
type Service interface {
	// AnalyzeNews processes a news article analysis request.
	// It accepts either a URL or raw text content for analysis.
	AnalyzeNews(ctx context.Context, url, text string) (analysis.Result, error)
}
