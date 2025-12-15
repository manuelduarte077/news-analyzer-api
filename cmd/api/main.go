package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/manuelduarte077/news-analyzer-api/internal/db"
	"github.com/manuelduarte077/news-analyzer-api/internal/handlers"
)

func main() {
	database, err := db.Init()
	log.Println("Database initialized")
	log.Println("Database stats:", database.Stats())
	if err != nil {
		log.Fatal(err)
	}

	app := fiber.New()

	app.Post("/analyze", handlers.AnalyzeNews(database))

	log.Fatal(app.Listen(":8080"))
}
