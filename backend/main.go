package main

import (
	"github.com/gin-gonic/gin"
	_ "github.com/mattn/go-sqlite3"
	"log"
)

func main() {
	InitializeDatabase()

	router := gin.Default()

	router.POST("/authenticate", Authenticate)
	router.POST("/refresh-token", RefreshToken)
	router.GET("/names", GetNames)
	router.POST("/names", JWTMiddleware(), AddName)

	if err := router.Run(":8000"); err != nil {
		log.Fatal(err)
	}
}
