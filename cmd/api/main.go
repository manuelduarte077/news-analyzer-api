package main

import (
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	analyzerAdapter "github.com/manuelduarte077/news-analyzer-api/internal/adapters/external/analyzer"
	extractorAdapter "github.com/manuelduarte077/news-analyzer-api/internal/adapters/external/extractor"
	analysisHandler "github.com/manuelduarte077/news-analyzer-api/internal/adapters/http/analysis"
	favoritesHandler "github.com/manuelduarte077/news-analyzer-api/internal/adapters/http/favorites"
	historyHandler "github.com/manuelduarte077/news-analyzer-api/internal/adapters/http/history"
	analysisRepo "github.com/manuelduarte077/news-analyzer-api/internal/adapters/persistence/analysis"
	favoritesRepo "github.com/manuelduarte077/news-analyzer-api/internal/adapters/persistence/favorites"
	historyRepo "github.com/manuelduarte077/news-analyzer-api/internal/adapters/persistence/history"
	sqliteDB "github.com/manuelduarte077/news-analyzer-api/internal/adapters/persistence/sqlite"
	analysisService "github.com/manuelduarte077/news-analyzer-api/internal/features/analysis"
	favoritesService "github.com/manuelduarte077/news-analyzer-api/internal/features/favorites"
	historyService "github.com/manuelduarte077/news-analyzer-api/internal/features/history"
)

func main() {
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

	// Initialize handlers
	analysisHdl := analysisHandler.NewHandler(analysisSvc)
	historyHdl := historyHandler.NewHandler(historySvc)
	favoritesHdl := favoritesHandler.NewHandler(favoritesSvc)

	app := fiber.New(fiber.Config{
		ErrorHandler: func(c *fiber.Ctx, err error) error {
			code := fiber.StatusInternalServerError
			if e, ok := err.(*fiber.Error); ok {
				code = e.Code
			}
			return c.Status(code).JSON(fiber.Map{
				"error": err.Error(),
			})
		},
	})

	// Register routes
	app.Post("/analyze", analysisHdl.AnalyzeNews())
	app.Get("/history", historyHdl.GetHistory())
	app.Post("/favorites", favoritesHdl.SaveFavorite())
	app.Get("/favorites", favoritesHdl.GetFavorites())
	app.Delete("/favorites/:id", favoritesHdl.DeleteFavorite())

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server starting on port %s", port)
	if err := app.Listen(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
