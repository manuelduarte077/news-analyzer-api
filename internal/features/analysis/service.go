package analysis

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/analysis"
	analysisPort "github.com/manuelduarte077/news-analyzer-api/internal/ports/analysis"
	"github.com/manuelduarte077/news-analyzer-api/internal/ports/external"
)

type service struct {
	analyzer  external.Analyzer
	extractor external.Extractor
	repo      analysisPort.Repository
}

// NewService creates a new analysis service instance.
func NewService(
	analyzer external.Analyzer,
	extractor external.Extractor,
	repo analysisPort.Repository,
) analysisPort.Service {
	return &service{
		analyzer:  analyzer,
		extractor: extractor,
		repo:      repo,
	}
}

// AnalyzeNews processes a news article analysis request.
func (s *service) AnalyzeNews(ctx context.Context, url, text string) (analysis.Result, error) {
	if url == "" && text == "" {
		return analysis.Result{}, fmt.Errorf("either url or text must be provided")
	}

	var content string
	var err error

	if url != "" {
		content, err = s.extractor.FromURL(ctx, url)
		if err != nil {
			return analysis.Result{}, fmt.Errorf("failed to extract content from URL: %w", err)
		}
	} else {
		content = text
	}

	if content == "" {
		return analysis.Result{}, fmt.Errorf("no content available for analysis")
	}

	hash := computeHash(content)

	if cached, ok := s.repo.FindByHash(ctx, hash); ok {
		var result analysis.Result
		if err := json.Unmarshal([]byte(cached), &result); err == nil {
			return result, nil
		}
	}

	result, err := s.analyzer.Analyze(ctx, content)
	if err != nil {
		return analysis.Result{}, fmt.Errorf("failed to analyze content: %w", err)
	}

	raw, err := json.Marshal(result)
	if err != nil {
		return analysis.Result{}, fmt.Errorf("failed to serialize result: %w", err)
	}

	if err := s.repo.Save(ctx, hash, string(raw)); err != nil {
		return analysis.Result{}, fmt.Errorf("failed to save result: %w", err)
	}

	return result, nil
}

func computeHash(text string) string {
	hashBytes := sha256.Sum256([]byte(text))
	return hex.EncodeToString(hashBytes[:])
}

