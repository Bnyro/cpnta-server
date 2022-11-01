package main

import (
	"log"

	"github.com/cpnta-server/config"
	"github.com/cpnta-server/handlers"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func main() {
	app := fiber.New()

	app.Use(cors.New(cors.Config{
		AllowHeaders: "Origin, Content-Type, Accept, Authorization",
	}))

	config.Connect()

	app.Get("/notes", handlers.GetNotes)
	app.Post("/notes", handlers.CreateNote)
	app.Delete("/notes/:id", handlers.DeleteNote)
	app.Patch("/notes", handlers.UpdateNote)

	log.Fatal(app.Listen(":8000"))
}
