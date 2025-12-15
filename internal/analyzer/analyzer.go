package analyzer

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strings"
	"sync"

	"github.com/manuelduarte077/news-analyzer-api/internal/models"
	openai "github.com/sashabaranov/go-openai"
)

var (
	clientOnce       sync.Once
	client           *openai.Client
	markdownRegex    = regexp.MustCompile(`(?s)^\s*` + "```" + `(?:json)?\s*\n?`)
	markdownEndRegex = regexp.MustCompile(`(?s)\n?\s*` + "```" + `\s*$`)
	newlineRegex     = regexp.MustCompile(`\n+`)
	spaceRegex       = regexp.MustCompile(`\s+`)
)

// Analyze performs the analysis of the given text using OpenAI's API.
//
// Parameters:
//   - text: The text content of the news article to analyze
//
// Returns:
//   - models.AnalysisResult: The structured analysis result
//   - error: An error if the analysis fails
func getClient() (*openai.Client, error) {
	var err error
	clientOnce.Do(func() {
		apiKey := os.Getenv("OPENAI_API_KEY")
		if apiKey == "" {
			err = fmt.Errorf("OPENAI_API_KEY environment variable is not set")
			return
		}
		client = openai.NewClient(apiKey)
	})
	return client, err
}

func Analyze(text string) (models.AnalysisResult, error) {
	client, err := getClient()
	if err != nil {
		return models.AnalysisResult{}, err
	}

	resp, err := client.CreateChatCompletion(
		context.Background(),
		openai.ChatCompletionRequest{
			Model: openai.GPT4oMini,
			Messages: []openai.ChatCompletionMessage{
				{Role: "system", Content: "Analista experto en noticias."},
				{Role: "user", Content: BuildPrompt(text)},
			},
			Temperature: 0.25,
		},
	)
	if err != nil {
		return models.AnalysisResult{}, err
	}

	// Check if we have any choices in the response
	if len(resp.Choices) == 0 {
		return models.AnalysisResult{}, fmt.Errorf("OpenAI API returned no choices")
	}

	content := resp.Choices[0].Message.Content
	cleanedContent := cleanJSON(content)

	var flexibleResult struct {
		Summary     interface{}   `json:"summary"`
		Biases      []string      `json:"biases"`
		Risks       []string      `json:"risks"`
		MissingInfo []string      `json:"missing_info"`
		Scores      models.Scores `json:"scores"`
	}

	// Parse the JSON response
	if err := json.Unmarshal([]byte(cleanedContent), &flexibleResult); err != nil {
		return models.AnalysisResult{}, fmt.Errorf("failed to parse OpenAI response as JSON: %w. Response content: %s", err, cleanedContent)
	}

	// Normalize summary field (convert string to []string if needed)
	summary := normalizeSummary(flexibleResult.Summary)

	// Build the final result
	result := models.AnalysisResult{
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
