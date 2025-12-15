package commands

import (
	"context"
	"encoding/json"
	"fmt"
	"os"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/history"
	historyPort "github.com/manuelduarte077/news-analyzer-api/internal/ports/history"
	"github.com/spf13/cobra"
)

// NewHistoryCommand creates the history command.
func NewHistoryCommand(service historyPort.Service) *cobra.Command {
	var page, pageSize int
	var outputJSON bool

	cmd := &cobra.Command{
		Use:   "history",
		Short: "List analysis history",
		Long: `List paginated analysis history. Shows all previously analyzed articles
with their results, biases, risks, and scores.`,
		Example: `  # List first page (default)
  news-analyzer history

  # List specific page
  news-analyzer history --page 2 --page-size 20

  # Output as JSON
  news-analyzer history --json`,
		RunE: func(cmd *cobra.Command, args []string) error {
			ctx := context.Background()
			result, err := service.GetHistory(ctx, page, pageSize)
			if err != nil {
				return fmt.Errorf("failed to retrieve history: %w", err)
			}

			if outputJSON {
				encoder := json.NewEncoder(os.Stdout)
				encoder.SetIndent("", "  ")
				return encoder.Encode(result)
			}

			// Pretty print
			printHistoryResult(result)
			return nil
		},
	}

	cmd.Flags().IntVarP(&page, "page", "p", 1, "Page number (default: 1)")
	cmd.Flags().IntVarP(&pageSize, "page-size", "s", 10, "Number of items per page (default: 10, max: 100)")
	cmd.Flags().BoolVarP(&outputJSON, "json", "j", false, "Output result as JSON")

	return cmd
}

func printHistoryResult(result history.Response) {
	// This will be implemented to show a nice table format
	// For now, use JSON
	data, err := json.MarshalIndent(result, "", "  ")
	if err != nil {
		fmt.Printf("Error formatting result: %v\n", err)
		return
	}
	fmt.Println(string(data))
}
