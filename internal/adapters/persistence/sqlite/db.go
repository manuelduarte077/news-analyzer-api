package sqlite

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
)

// Init initializes the SQLite database and creates necessary tables.
func Init() (*sql.DB, error) {
	db, err := sql.Open("sqlite3", "./data/news.db")
	if err != nil {
		return nil, err
	}

	// Enable foreign keys
	if _, err := db.Exec("PRAGMA foreign_keys = ON"); err != nil {
		return nil, err
	}

	schema := `
	CREATE TABLE IF NOT EXISTS analysis (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		input_hash TEXT UNIQUE,
		result TEXT,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	);
	CREATE TABLE IF NOT EXISTS favorites (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		analysis_id INTEGER NOT NULL,
		result TEXT NOT NULL,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY (analysis_id) REFERENCES analysis(id) ON DELETE CASCADE,
		UNIQUE(analysis_id)
	);`

	_, err = db.Exec(schema)
	return db, err
}

