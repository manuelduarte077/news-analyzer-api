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
