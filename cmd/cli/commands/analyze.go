package commands

import (
	"context"
	"encoding/json"
	"fmt"
	"os"

	analysisPort "github.com/manuelduarte077/news-analyzer-api/internal/ports/analysis"
	"github.com/spf13/cobra"
)

// NewAnalyzeCommand creates the analyze command.
func NewAnalyzeCommand(service analysisPort.Service) *cobra.Command {
	var url, text string
	var outputJSON bool

	cmd := &cobra.Command{
		Use:   "analyze",
		Short: "Analyze a news article",
		Long: `Analyze a news article by providing either a URL or text content.
The analysis will identify biases, risks, missing information, and provide quality scores.`,
		Example: `  # Analyze from URL
  news-analyzer analyze --url https://example.com/article

  # Analyze from text
  news-analyzer analyze --text "Article content here..."

  # Output as JSON
  news-analyzer analyze --url https://example.com/article --json`,
		RunE: func(cmd *cobra.Command, args []string) error {
			if url == "" && text == "" {
				return fmt.Errorf("either --url or --text must be provided")
			}

			ctx := context.Background()
			result, err := service.AnalyzeNews(ctx, url, text)
			if err != nil {
				return fmt.Errorf("failed to analyze: %w", err)
			}

			if outputJSON {
				encoder := json.NewEncoder(os.Stdout)
				encoder.SetIndent("", "  ")
				return encoder.Encode(result)
			}

			// Pretty print
			printAnalysisResult(result)
			return nil
		},
	}

	cmd.Flags().StringVarP(&url, "url", "u", "", "URL of the news article to analyze")
	cmd.Flags().StringVarP(&text, "text", "t", "", "Text content of the news article to analyze")
	cmd.Flags().BoolVarP(&outputJSON, "json", "j", false, "Output result as JSON")

	return cmd
}

func printAnalysisResult(result interface{}) {
	// Convert to JSON for pretty printing
	data, err := json.MarshalIndent(result, "", "  ")
	if err != nil {
		fmt.Printf("Error formatting result: %v\n", err)
		return
	}
	fmt.Println(string(data))
}
