package models

// Favorite represents a favorite analysis entry.
type Favorite struct {
	ID        int64          `json:"id"`
	AnalysisID int64          `json:"analysis_id"`
	Result    AnalysisResult `json:"result"`
	CreatedAt string         `json:"created_at"`
}

// FavoriteListResponse represents the paginated favorites response.
type FavoriteListResponse struct {
	Items      []Favorite `json:"items"`
	Total      int        `json:"total"`
	Page       int        `json:"page"`
	PageSize   int        `json:"page_size"`
	TotalPages int        `json:"total_pages"`
}

