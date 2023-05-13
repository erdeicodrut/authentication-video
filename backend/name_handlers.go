package main

import (
	"database/sql"
	"github.com/gin-gonic/gin"
	"net/http"
)

// GetNames returns the list of names
func GetNames(c *gin.Context) {
	db, err := sql.Open("sqlite3", "./names.db")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer db.Close()

	rows, err := db.Query("SELECT id, name FROM names")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var names []Name
	for rows.Next() {
		var name Name
		if err := rows.Scan(&name.ID, &name.Name); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		names = append(names, name)
	}

	if err := rows.Err(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, names)
}

// AddName adds a new name to the database
func AddName(c *gin.Context) {
	var name Name
	if err := c.ShouldBindJSON(&name); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Save the name to the database (you can replace this with your own database insertion logic)
	db, err := sql.Open("sqlite3", "./names.db")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer db.Close()

	insertQuery := "INSERT INTO names (name) VALUES (?)"
	_, err = db.Exec(insertQuery, name.Name)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.Status(http.StatusCreated)
}
