package db

import (
	"database/sql" // SQLite database/sql package

	_ "github.com/mattn/go-sqlite3" // SQLite driver
)

// Init initializes the SQLite database and creates necessary tables.
func Init() (*sql.DB, error) {
	db, err := sql.Open("sqlite3", "./data/news.db")
	if err != nil {
		return nil, err
	}

	schema := `
	CREATE TABLE IF NOT EXISTS analysis (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		input_hash TEXT UNIQUE,
		result TEXT,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	);`

	_, err = db.Exec(schema)
	return db, err
}
