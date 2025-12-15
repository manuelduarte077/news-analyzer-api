package db

import "database/sql"

func Save(db *sql.DB, hash string, result string) error {
	_, err := db.Exec(
		"INSERT OR IGNORE INTO analysis (input_hash, result) VALUES (?, ?)",
		hash, result,
	)
	return err
}

func FindByHash(db *sql.DB, hash string) (string, bool) {
	row := db.QueryRow(
		"SELECT result FROM analysis WHERE input_hash = ?",
		hash,
	)

	var result string
	err := row.Scan(&result)
	return result, err == nil
}
