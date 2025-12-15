package models

// Scores represents the various scoring metrics for an analysis.
type Scores struct {
	Objectivity   int     `json:"objectivity"`
	Clarity       int     `json:"clarity"`
	SourceQuality int     `json:"source_quality"`
	Overall       float64 `json:"overall"`
}

// AnalysisResult represents the result of an analysis on a news article.
type AnalysisResult struct {
	Summary     []string `json:"summary"`
	Biases      []string `json:"biases"`
	Risks       []string `json:"risks"`
	MissingInfo []string `json:"missing_info"`
	Scores      Scores   `json:"scores"`
}

// AnalysisHistory represents a historical analysis entry.
type AnalysisHistory struct {
	ID        int64          `json:"id"`
	Result    AnalysisResult `json:"result"`
	CreatedAt string         `json:"created_at"`
}

// HistoryResponse represents the paginated history response.
type HistoryResponse struct {
	Items      []AnalysisHistory `json:"items"`
	Total      int               `json:"total"`
	Page       int               `json:"page"`
	PageSize   int               `json:"page_size"`
	TotalPages int               `json:"total_pages"`
}
