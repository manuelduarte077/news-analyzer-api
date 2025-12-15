package extractor

import (
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
)

var httpClient = &http.Client{
	Timeout: 30 * time.Second,
}

// FromURL extracts text content from a web page at the given URL.
// It fetches the HTML document from the URL, parses it, and extracts text
// from paragraph elements within article tags (<article p>).
//
// Parameters:
//   - url: The URL of the web page to extract content from
//
// Returns:
//   - string: The extracted text content, with paragraphs separated by newlines
//   - error: An error if the HTTP request fails, the document cannot be parsed,
//     or if extraction fails
func FromURL(url string) (string, error) {
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return "", err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")

	resp, err := httpClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	// Check if the response status is successful
	if resp.StatusCode != http.StatusOK {
		return "", &HTTPError{
			StatusCode: resp.StatusCode,
			URL:        url,
		}
	}

	// Parse the HTML document
	doc, err := goquery.NewDocumentFromReader(resp.Body)
	if err != nil {
		return "", err
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

	return strings.TrimSpace(text.String()), nil
}

// HTTPError represents an error that occurred during an HTTP request.
type HTTPError struct {
	StatusCode int
	URL        string
}

func (e *HTTPError) Error() string {
	return fmt.Sprintf("HTTP error %d when fetching %s", e.StatusCode, e.URL)
}
