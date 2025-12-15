package favorites

import "github.com/manuelduarte077/news-analyzer-api/internal/domain/analysis"

// Favorite represents a favorite analysis entry.
type Favorite struct {
	ID         int64            `json:"id"`
	AnalysisID int64            `json:"analysis_id"`
	Result     analysis.Result  `json:"result"`
	CreatedAt  string           `json:"created_at"`
}

// ListResponse represents the paginated favorites response.
type ListResponse struct {
	Items      []Favorite `json:"items"`
	Total      int        `json:"total"`
	Page       int        `json:"page"`
	PageSize   int        `json:"page_size"`
	TotalPages int        `json:"total_pages"`
}

