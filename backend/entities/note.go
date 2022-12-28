package entities

import (
	"gorm.io/gorm"
)

type Note struct {
	gorm.Model
	Title   string `json:"title"`
	Content string `json:"content"`
	Token   string `json:"token"`
}
