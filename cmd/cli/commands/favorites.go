package commands

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strconv"

	"github.com/manuelduarte077/news-analyzer-api/internal/domain/favorites"
	favoritesPort "github.com/manuelduarte077/news-analyzer-api/internal/ports/favorites"
	"github.com/spf13/cobra"
)

// NewFavoritesCommand creates the favorites command group.
func NewFavoritesCommand(service favoritesPort.Service) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "favorites",
		Short: "Manage favorite analyses",
		Long:  `Manage your favorite analyses. You can list, add, and delete favorites.`,
	}

	cmd.AddCommand(newFavoritesListCommand(service))
	cmd.AddCommand(newFavoritesAddCommand(service))
	cmd.AddCommand(newFavoritesDeleteCommand(service))

	return cmd
}

// newFavoritesListCommand creates the list subcommand.
func newFavoritesListCommand(service favoritesPort.Service) *cobra.Command {
	var page, pageSize int
	var outputJSON bool

	cmd := &cobra.Command{
		Use:   "list",
		Short: "List favorite analyses",
		Long:  `List paginated favorite analyses.`,
		Example: `  # List favorites
  news-analyzer favorites list

  # List specific page
  news-analyzer favorites list --page 2 --page-size 20

  # Output as JSON
  news-analyzer favorites list --json`,
		RunE: func(cmd *cobra.Command, args []string) error {
			ctx := context.Background()
			result, err := service.GetFavorites(ctx, page, pageSize)
			if err != nil {
				return fmt.Errorf("failed to retrieve favorites: %w", err)
			}

			if outputJSON {
				encoder := json.NewEncoder(os.Stdout)
				encoder.SetIndent("", "  ")
				return encoder.Encode(result)
			}

			printFavoritesResult(result)
			return nil
		},
	}

	cmd.Flags().IntVarP(&page, "page", "p", 1, "Page number (default: 1)")
	cmd.Flags().IntVarP(&pageSize, "page-size", "s", 10, "Number of items per page (default: 10, max: 100)")
	cmd.Flags().BoolVarP(&outputJSON, "json", "j", false, "Output result as JSON")

	return cmd
}

// newFavoritesAddCommand creates the add subcommand.
func newFavoritesAddCommand(service favoritesPort.Service) *cobra.Command {
	var analysisID int64

	cmd := &cobra.Command{
		Use:   "add",
		Short: "Add an analysis to favorites",
		Long:  `Add an analysis result to your favorites by providing its analysis ID.`,
		Example: `  # Add analysis to favorites
  news-analyzer favorites add --analysis-id 1`,
		RunE: func(cmd *cobra.Command, args []string) error {
			if analysisID <= 0 {
				return fmt.Errorf("analysis-id must be a positive integer")
			}

			ctx := context.Background()
			favorite, err := service.SaveFavorite(ctx, analysisID)
			if err != nil {
				return fmt.Errorf("failed to save favorite: %w", err)
			}

			encoder := json.NewEncoder(os.Stdout)
			encoder.SetIndent("", "  ")
			return encoder.Encode(favorite)
		},
	}

	cmd.Flags().Int64VarP(&analysisID, "analysis-id", "a", 0, "Analysis ID to add to favorites (required)")
	cmd.MarkFlagRequired("analysis-id")

	return cmd
}

// newFavoritesDeleteCommand creates the delete subcommand.
func newFavoritesDeleteCommand(service favoritesPort.Service) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "delete",
		Short: "Delete a favorite",
		Long:  `Delete a favorite analysis by its ID.`,
		Example: `  # Delete favorite by ID
  news-analyzer favorites delete 1`,
		Args: cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			id, err := strconv.ParseInt(args[0], 10, 64)
			if err != nil || id <= 0 {
				return fmt.Errorf("invalid favorite ID: %s (must be a positive integer)", args[0])
			}

			ctx := context.Background()
			if err := service.DeleteFavorite(ctx, id); err != nil {
				return fmt.Errorf("failed to delete favorite: %w", err)
			}

			fmt.Printf("Favorite %d deleted successfully\n", id)
			return nil
		},
	}

	return cmd
}

func printFavoritesResult(result favorites.ListResponse) {
	// Pretty print favorites
	data, err := json.MarshalIndent(result, "", "  ")
	if err != nil {
		fmt.Printf("Error formatting result: %v\n", err)
		return
	}
	fmt.Println(string(data))
}
