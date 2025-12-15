package analyzer

func BuildPrompt(text string) string {
	return `
Eres un analista profesional de medios.

Reglas:
- No inventes información
- Sé neutral
- Señala incertidumbres

Devuelve SOLO JSON con esta estructura:

{
  "summary": [string],
  "biases": [string],
  "risks": [string],
  "missing_info": [string],
  "scores": {
    "objectivity": number,
    "clarity": number,
    "source_quality": number,
    "overall": number
  }
}

Noticia:
"""
` + text + `
"""
`
}
