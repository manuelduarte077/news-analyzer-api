package external

import "context"

// Extractor defines the interface for content extraction operations.
// It provides methods for extracting text content from web pages.
type Extractor interface {
	// FromURL extracts text content from a web page at the given URL.
	// It fetches the HTML, parses it, and extracts text from paragraph elements.
	FromURL(ctx context.Context, url string) (string, error)
}

