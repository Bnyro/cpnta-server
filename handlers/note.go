package handlers

import (
	"strconv"

	"github.com/cpnta-server/config"
	"github.com/cpnta-server/entities"
	"github.com/gofiber/fiber/v2"
)

func GetNotes(c *fiber.Ctx) error {
	var notes []entities.Note

	var token string
	var valid bool

	if token, valid = authValid(c); !valid {
		return c.SendStatus(403)
	}

	config.Database.Find(&notes, entities.Note{
		Token: token,
	})

	return c.Status(200).JSON(notes)
}

func CreateNote(c *fiber.Ctx) error {
	note := new(entities.Note)

	var token string
	var valid bool

	if token, valid = authValid(c); !valid {
		return c.SendStatus(403)
	}

	if err := c.BodyParser(note); err != nil {
		return c.Status(503).SendString(err.Error())
	}

	note.Token = token

	config.Database.Create(&note)
	return c.Status(201).JSON(note)
}

func UpdateNote(c *fiber.Ctx) error {
	note := new(entities.Note)

	if _, valid := authValid(c); !valid {
		return c.SendStatus(403)
	}

	if err := c.BodyParser(note); err != nil {
		return c.Status(503).SendString(err.Error())
	}

	config.Database.Where("id = ?", note.ID).Updates(&note)
	return c.Status(200).JSON(note)
}

func DeleteNote(c *fiber.Ctx) error {
	var note entities.Note

	if _, valid := authValid(c); !valid {
		return c.SendStatus(403)
	}

	id, _ := strconv.Atoi(c.Params("id"))

	result := config.Database.Delete(&note, id)

	if result.RowsAffected == 0 {
		return c.SendStatus(404)
	}

	return c.SendStatus(200)
}

func authValid(c *fiber.Ctx) (string, bool) {
	token := c.GetReqHeaders()["Authorization"]
	valid := token != "" && len(token) == 20
	return token, valid
}
