package config

import (
	"github.com/cpnta-server/entities"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var Database *gorm.DB

const DATABASE_URI = "postgres://postgres@localhost/cpnta"

func Connect() error {
	var err error

	Database, err = gorm.Open(
		postgres.Open(DATABASE_URI),
		&gorm.Config{
			SkipDefaultTransaction: true,
			PrepareStmt:            true,
		})

	if err != nil {
		panic(err)
	}

	Database.AutoMigrate(&entities.Note{})

	return nil
}
