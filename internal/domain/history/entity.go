package history

import "github.com/manuelduarte077/news-analyzer-api/internal/domain/analysis"

// Entry represents a historical analysis entry.
type Entry struct {
	ID        int64            `json:"id"`
	Result    analysis.Result `json:"result"`
	CreatedAt string          `json:"created_at"`
}

// Response represents the paginated history response.
type Response struct {
	Items      []Entry `json:"items"`
	Total      int     `json:"total"`
	Page       int     `json:"page"`
	PageSize   int     `json:"page_size"`
	TotalPages int     `json:"total_pages"`
}

