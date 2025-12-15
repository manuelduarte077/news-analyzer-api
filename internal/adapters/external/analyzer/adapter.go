package analyzer

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strings"
	"sync"
	"time"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/analysis"
	"github.com/manuelduarte077/news-analyzer-api/internal/ports/external"
	openai "github.com/sashabaranov/go-openai"
)

type adapter struct {
	client *openai.Client
}

var (
	clientOnce       sync.Once
	client           *openai.Client
	markdownRegex    = regexp.MustCompile(`(?s)^\s*` + "```" + `(?:json)?\s*\n?`)
	markdownEndRegex = regexp.MustCompile(`(?s)\n?\s*` + "```" + `\s*$`)
	newlineRegex     = regexp.MustCompile(`\n+`)
	spaceRegex       = regexp.MustCompile(`\s+`)
)

// NewAdapter creates a new analyzer adapter instance.
func NewAdapter() (external.Analyzer, error) {
	apiKey := os.Getenv("OPENAI_API_KEY")
	if apiKey == "" {
		return nil, fmt.Errorf("OPENAI_API_KEY environment variable is not set")
	}

	clientOnce.Do(func() {
		client = openai.NewClient(apiKey)
	})

	return &adapter{client: client}, nil
}

// Analyze performs the analysis of the given text using OpenAI's API.
func (a *adapter) Analyze(ctx context.Context, text string) (analysis.Result, error) {
	if text == "" {
		return analysis.Result{}, fmt.Errorf("text cannot be empty")
	}

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	resp, err := a.client.CreateChatCompletion(
		ctx,
		openai.ChatCompletionRequest{
			Model: openai.GPT4oMini,
			Messages: []openai.ChatCompletionMessage{
				{Role: "system", Content: "Analista experto en noticias."},
				{Role: "user", Content: buildPrompt(text)},
			},
			Temperature: 0.25,
		},
	)
	if err != nil {
		return analysis.Result{}, fmt.Errorf("OpenAI API error: %w", err)
	}

	if len(resp.Choices) == 0 {
		return analysis.Result{}, fmt.Errorf("OpenAI API returned no choices")
	}

	content := resp.Choices[0].Message.Content
	cleanedContent := cleanJSON(content)

	var flexibleResult struct {
		Summary     interface{}     `json:"summary"`
		Biases      []string        `json:"biases"`
		Risks       []string        `json:"risks"`
		MissingInfo []string        `json:"missing_info"`
		Scores      analysis.Scores `json:"scores"`
	}

	if err := json.Unmarshal([]byte(cleanedContent), &flexibleResult); err != nil {
		return analysis.Result{}, fmt.Errorf("failed to parse OpenAI response as JSON: %w", err)
	}

	summary := normalizeSummary(flexibleResult.Summary)

	result := analysis.Result{
		Summary:     summary,
		Biases:      flexibleResult.Biases,
		Risks:       flexibleResult.Risks,
		MissingInfo: flexibleResult.MissingInfo,
		Scores:      flexibleResult.Scores,
	}

	return result, nil
}

func normalizeSummary(v interface{}) []string {
	switch val := v.(type) {
	case string:
		if val != "" {
			return []string{val}
		}
	case []interface{}:
		result := make([]string, 0, len(val))
		for _, item := range val {
			if str, ok := item.(string); ok {
				result = append(result, str)
			}
		}
		return result
	case []string:
		return val
	}
	return []string{}
}

func cleanJSON(jsonStr string) string {
	jsonStr = markdownRegex.ReplaceAllString(jsonStr, "")
	jsonStr = markdownEndRegex.ReplaceAllString(jsonStr, "")

	jsonStart := strings.Index(jsonStr, "{")
	jsonEnd := strings.LastIndex(jsonStr, "}")
	if jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart {
		jsonStr = jsonStr[jsonStart : jsonEnd+1]
	}

	jsonStr = strings.TrimSpace(jsonStr)
	jsonStr = newlineRegex.ReplaceAllString(jsonStr, " ")
	jsonStr = spaceRegex.ReplaceAllString(jsonStr, " ")

	return jsonStr
}

func buildPrompt(text string) string {
	return `
Eres un analista profesional de medios.

Reglas:
- No inventes información
- Sé neutral
- Señala incertidumbres

Devuelve SOLO JSON con esta estructura:

{
  "summary": [string],
  "biases": [string],
  "risks": [string],
  "missing_info": [string],
  "scores": {
    "objectivity": number,
    "clarity": number,
    "source_quality": number,
    "overall": number
  }
}

Noticia:
"""
` + text + `
"""
`
}
