package main

import (
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/analyzer"
	"github.com/manuelduarte077/news-analyzer-api/internal/db"
	"github.com/manuelduarte077/news-analyzer-api/internal/extractor"
	"github.com/manuelduarte077/news-analyzer-api/internal/handlers"
	"github.com/manuelduarte077/news-analyzer-api/internal/service"
)

func main() {
	database, err := db.Init()
	if err != nil {
		log.Fatalf("Failed to initialize database: %v", err)
	}
	defer database.Close()

	repo := db.NewRepository(database)

	analyzerSvc, err := analyzer.NewAnalyzer()
	if err != nil {
		log.Fatalf("Failed to initialize analyzer: %v", err)
	}

	extractorSvc := extractor.NewExtractor(nil)
	svc := service.NewService(analyzerSvc, extractorSvc, repo)

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

	app.Post("/analyze", handlers.AnalyzeNews(svc))
	app.Get("/history", handlers.GetHistory(svc))

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server starting on port %s", port)
	if err := app.Listen(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
