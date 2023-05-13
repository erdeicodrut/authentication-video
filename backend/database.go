package main

import (
	"database/sql"
	"log"
)

// InitializeDatabase creates the necessary tables in the SQLite database
func InitializeDatabase() {
	db, err := sql.Open("sqlite3", "./names.db")
	if err != nil {
		log.Fatal(err)
	}
	defer func(db *sql.DB) {
		err := db.Close()
		if err != nil {
			log.Fatal(err)
		}
	}(db)

	createTableQuery := `
		CREATE TABLE IF NOT EXISTS names (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			name TEXT NOT NULL
		);
	`

	_, err = db.Exec(createTableQuery)
	if err != nil {
		log.Fatal(err)
	}
}
