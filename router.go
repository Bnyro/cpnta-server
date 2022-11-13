package main

import (
	"log"

	"github.com/cpnta-server/entities"
	"github.com/cpnta-server/handlers"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func CreateRouter() {
	app := fiber.New()

	app.Use(cors.New(cors.Config{
		AllowHeaders: "Origin, Content-Type, Accept, Authorization",
	}))

	app.Get("/", func(c *fiber.Ctx) error {
		return c.Status(200).JSON(entities.Message{
			Message: "API online",
		})
	})

	app.Get("/notes", handlers.GetNotes)
	app.Post("/notes", handlers.CreateNote)
	app.Patch("/notes", handlers.UpdateNote)
	app.Delete("/notes/:id", handlers.DeleteNote)
	app.Delete("/notes", handlers.DeleteAllNotes)

	log.Fatal(app.Listen(":8001"))
}
