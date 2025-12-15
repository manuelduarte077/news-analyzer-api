package extractor

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
)

// Extractor defines the interface for content extraction operations.
type Extractor interface {
	FromURL(ctx context.Context, url string) (string, error)
}

type extractor struct {
	client *http.Client
}

var defaultHTTPClient = &http.Client{
	Timeout: 30 * time.Second,
}

// NewExtractor creates a new extractor instance.
func NewExtractor(client *http.Client) Extractor {
	if client == nil {
		client = defaultHTTPClient
	}
	return &extractor{client: client}
}

// HTTPError represents an error that occurred during an HTTP request.
type HTTPError struct {
	StatusCode int
	URL        string
}

func (e *HTTPError) Error() string {
	return fmt.Sprintf("HTTP error %d when fetching %s", e.StatusCode, e.URL)
}

// FromURL extracts text content from a web page at the given URL.
func (e *extractor) FromURL(ctx context.Context, url string) (string, error) {
	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return "", fmt.Errorf("failed to create request: %w", err)
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")

	resp, err := e.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to fetch URL: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", &HTTPError{
			StatusCode: resp.StatusCode,
			URL:        url,
		}
	}

	doc, err := goquery.NewDocumentFromReader(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to parse HTML: %w", err)
	}

	var text strings.Builder
	selectors := []string{
		"article p",
		"main p, .content p, .article-content p, .post-content p",
		"p",
	}

	for _, selector := range selectors {
		doc.Find(selector).Each(func(i int, s *goquery.Selection) {
			if content := strings.TrimSpace(s.Text()); content != "" {
				text.WriteString(content + "\n")
			}
		})
		if text.Len() > 0 {
			break
		}
	}

	result := strings.TrimSpace(text.String())
	if result == "" {
		return "", fmt.Errorf("no content extracted from URL: %s", url)
	}

	return result, nil
}
