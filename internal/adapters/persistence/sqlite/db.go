package sqlite

import (
	"database/sql"
	"fmt"

	_ "github.com/mattn/go-sqlite3"
)

// Init initializes the SQLite database and creates necessary tables.
func Init() (*sql.DB, error) {
	db, err := sql.Open("sqlite3", "./data/news.db")
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %w", err)
	}

	// Enable foreign keys
	if _, err := db.Exec("PRAGMA foreign_keys = ON"); err != nil {
		db.Close()
		return nil, fmt.Errorf("failed to enable foreign keys: %w", err)
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

	if _, err := db.Exec(schema); err != nil {
		db.Close()
		return nil, fmt.Errorf("failed to create schema: %w", err)
	}

	return db, nil
}

// MustInit initializes the SQLite database and panics if initialization fails.
// This is a convenience function for applications that want to fail fast on database errors.
func MustInit() *sql.DB {
	db, err := Init()
	if err != nil {
		panic(fmt.Sprintf("Failed to initialize database: %v", err))
	}
	return db
}
