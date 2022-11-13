package main

import (
	"github.com/cpnta-server/config"
)

func main() {
	config.Connect()

	CreateRouter()
}
