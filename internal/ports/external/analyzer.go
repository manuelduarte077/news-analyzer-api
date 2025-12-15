package external

import (
	"context"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/analysis"
)

// Analyzer defines the interface for external analysis operations.
// It provides methods for analyzing news article content using AI.
type Analyzer interface {
	// Analyze performs the analysis of the given text using OpenAI's API.
	// It returns a structured analysis result with summary, biases, risks, and scores.
	Analyze(ctx context.Context, text string) (analysis.Result, error)
}
