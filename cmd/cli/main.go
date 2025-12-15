package main

import (
	"fmt"
	"os"

	"github.com/manuelduarte077/news-analyzer-api/cmd/cli/commands"
	analyzerAdapter "github.com/manuelduarte077/news-analyzer-api/internal/adapters/external/analyzer"
	extractorAdapter "github.com/manuelduarte077/news-analyzer-api/internal/adapters/external/extractor"
	analysisRepo "github.com/manuelduarte077/news-analyzer-api/internal/adapters/persistence/analysis"
	favoritesRepo "github.com/manuelduarte077/news-analyzer-api/internal/adapters/persistence/favorites"
	historyRepo "github.com/manuelduarte077/news-analyzer-api/internal/adapters/persistence/history"
	sqliteDB "github.com/manuelduarte077/news-analyzer-api/internal/adapters/persistence/sqlite"
	analysisService "github.com/manuelduarte077/news-analyzer-api/internal/features/analysis"
	favoritesService "github.com/manuelduarte077/news-analyzer-api/internal/features/favorites"
	historyService "github.com/manuelduarte077/news-analyzer-api/internal/features/history"
	"github.com/spf13/cobra"
)

var (
	version = "dev"
	commit  = "unknown"
	date    = "unknown"
)

func main() {
	// Initialize database
	database := sqliteDB.MustInit()
	defer database.Close()

	// Initialize repositories
	analysisRepository := analysisRepo.NewRepository(database)
	historyRepository := historyRepo.NewRepository(database)
	favoritesRepository := favoritesRepo.NewRepository(database)

	// Initialize external adapters
	analyzer := analyzerAdapter.MustNewAdapter()
	extractor := extractorAdapter.NewAdapter(nil)

	// Initialize services
	analysisSvc := analysisService.NewService(analyzer, extractor, analysisRepository)
	historySvc := historyService.NewService(historyRepository)
	favoritesSvc := favoritesService.NewService(analysisRepository, favoritesRepository)

	// Create root command
	rootCmd := &cobra.Command{
		Use:   "news-analyzer",
		Short: "A CLI tool for analyzing news articles",
		Long: `News Analyzer is a CLI tool that helps you analyze news articles
by extracting content, identifying biases, risks, and providing quality scores.`,
		Version: fmt.Sprintf("%s (commit: %s, built: %s)", version, commit, date),
	}

	// Add commands
	rootCmd.AddCommand(commands.NewAnalyzeCommand(analysisSvc))
	rootCmd.AddCommand(commands.NewHistoryCommand(historySvc))
	rootCmd.AddCommand(commands.NewFavoritesCommand(favoritesSvc))

	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
