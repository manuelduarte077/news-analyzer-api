# News Analyzer

A CLI tool for analyzing news articles by extracting content, identifying biases, risks, and providing quality scores.

## Architecture

The project follows **Hexagonal Architecture** (Ports and Adapters) with feature-based organization:

```
internal/
├── domain/              # Domain entities (no external dependencies)
│   ├── analysis/
│   ├── history/
│   └── favorites/
│
├── ports/               # Interfaces (contracts)
│   ├── analysis/        # Ports for analysis
│   ├── history/         # Ports for history
│   ├── favorites/      # Ports for favorites
│   └── external/        # Ports for external services
│
├── adapters/            # Implementations (adapters)
│   ├── persistence/     # Persistence adapters
│   │   ├── analysis/
│   │   ├── history/
│   │   ├── favorites/
│   │   └── sqlite/
│   ├── http/            # HTTP adapters (handlers)
│   │   ├── analysis/
│   │   ├── history/
│   │   └── favorites/
│   └── external/        # External adapters
│       ├── analyzer/
│       └── extractor/
│
└── features/            # Use cases (business logic)
    ├── analysis/
    ├── history/
    └── favorites/
```

## Features

- **Analyze News**: Analyze articles from URL or text content
- **History**: View paginated analysis history
- **Favorites**: Save, list, and delete favorite analyses

## Installation

### Build from source

```bash
go build -o bin/news-analyzer ./cmd/cli
```

### Install globally

```bash
go install ./cmd/cli
```

## Usage


### Analyze a news article

```bash
# Using go run (development)
go run cmd/cli/main.go analyze --url https://example.com/article
go run cmd/cli/main.go analyze --text "Article content here..."

# Using compiled binary
news-analyzer analyze --url https://example.com/article
news-analyzer analyze --text "Article content here..."

# Output as JSON
go run cmd/cli/main.go analyze --url https://example.com/article --json
```

### View history

```bash
# List first page (default)
go run cmd/cli/main.go history

# List specific page
go run cmd/cli/main.go history --page 2 --page-size 20

# Output as JSON
go run cmd/cli/main.go history --json
```

### Manage favorites

```bash
# List favorites
go run cmd/cli/main.go favorites list

# Add to favorites
go run cmd/cli/main.go favorites add --analysis-id 1

# Delete favorite
go run cmd/cli/main.go favorites delete 1
```

## Configuration

Set the `OPENAI_API_KEY` environment variable:

```bash
export OPENAI_API_KEY=your-api-key-here
```

## API Server

The project also includes an HTTP API server. To run it:

```bash
go run ./cmd/api
```

The API will be available at `http://localhost:8080` (or the port specified in the `PORT` environment variable).

### API Endpoints

- `POST /analyze` - Analyze a news article
- `GET /history` - Get analysis history
- `POST /favorites` - Add to favorites
- `GET /favorites` - List favorites
- `DELETE /favorites/:id` - Delete a favorite

## Development

### Project Structure

- `cmd/api/` - HTTP API server entry point
- `cmd/cli/` - CLI application entry point
- `cmd/cli/commands/` - CLI command implementations
- `internal/` - Internal packages following hexagonal architecture