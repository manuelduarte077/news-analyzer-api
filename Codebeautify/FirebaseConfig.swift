//
//  FirebaseConfig.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import Foundation
import FirebaseCore
import FirebaseAI
import SwiftUI

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    private init() {}
    
    // MARK: - AI Services
    func getGenerativeModel() -> GenerativeModel? {
        do {
            let ai = FirebaseAI.firebaseAI(backend: .googleAI())
            // Use the correct model name - gemini-1.5-flash is the current stable model
            return ai.generativeModel(modelName: "gemini-1.5-flash")
        } catch {
            print("Error creating generative model: \(error)")
            return nil
        }
    }
    
    func generateText(prompt: String) async throws -> String {
        guard let model = getGenerativeModel() else {
            throw NSError(domain: "FirebaseAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create generative model. Please check your Firebase configuration."])
        }
        
        do {
            print("Generating content with prompt: \(prompt.prefix(100))...")
            let response = try await model.generateContent(prompt)
            
            guard let text = response.text, !text.isEmpty else {
                throw NSError(domain: "FirebaseAI", code: -2, userInfo: [NSLocalizedDescriptionKey: "Empty response from AI. The model returned no content."])
            }
            
            print("Successfully generated content: \(text.prefix(100))...")
            return text
        } catch let error as NSError {
            print("Firebase AI Error: \(error)")
            print("Error domain: \(error.domain)")
            print("Error code: \(error.code)")
            print("Error userInfo: \(error.userInfo)")
            
            // Provide more specific error messages based on the error
            var errorMessage = "AI generation failed"
            
            if error.domain == "FirebaseAI.GenerateContentError" {
                switch error.code {
                case 0:
                    errorMessage = "Firebase AI service unavailable. Please check your internet connection and Firebase configuration."
                case 1:
                    errorMessage = "Invalid request to Firebase AI. Please check your prompt format."
                case 2:
                    errorMessage = "Firebase AI quota exceeded. Please try again later."
                case 3:
                    errorMessage = "Firebase AI permission denied. Please check your API key and project configuration."
                default:
                    errorMessage = "Firebase AI error: \(error.localizedDescription)"
                }
            } else {
                errorMessage = "AI generation failed: \(error.localizedDescription)"
            }
            
            throw NSError(domain: "FirebaseAI", code: -3, userInfo: [
                NSLocalizedDescriptionKey: errorMessage,
                NSUnderlyingErrorKey: error
            ])
        }
    }
    
    // MARK: - Code Generation with AI
    func generateCodeWithAI(jsonDescription: String, language: String, className: String) async throws -> String {
        let prompt = """
        Generate a \(language) class/struct named \(className) based on this JSON structure:
        
        \(jsonDescription)
        
        Requirements:
        - Use proper \(language) syntax and conventions
        - Include appropriate imports/dependencies
        - Add proper type annotations
        - Follow \(language) naming conventions
        - Make it production-ready code
        - Include proper documentation comments
        
        Return only the code, no explanations or markdown formatting.
        """
        
        do {
            return try await generateText(prompt: prompt)
        } catch {
            // If AI generation fails, provide a fallback basic structure
            print("AI generation failed, using fallback: \(error)")
            return generateFallbackCode(jsonDescription: jsonDescription, language: language, className: className)
        }
    }
    
    // MARK: - Fallback Code Generation
    func generateFallbackCode(jsonDescription: String, language: String, className: String) -> String {
        switch language.lowercased() {
        case "swift":
            return generateSwiftFallback(jsonDescription: jsonDescription, className: className)
        case "kotlin":
            return generateKotlinFallback(jsonDescription: jsonDescription, className: className)
        case "javascript", "js":
            return generateJavaScriptFallback(jsonDescription: jsonDescription, className: className)
        case "typescript", "ts":
            return generateTypeScriptFallback(jsonDescription: jsonDescription, className: className)
        case "python":
            return generatePythonFallback(jsonDescription: jsonDescription, className: className)
        case "java":
            return generateJavaFallback(jsonDescription: jsonDescription, className: className)
        case "c#", "csharp":
            return generateCSharpFallback(jsonDescription: jsonDescription, className: className)
        case "go":
            return generateGoFallback(jsonDescription: jsonDescription, className: className)
        case "rust":
            return generateRustFallback(jsonDescription: jsonDescription, className: className)
        case "php":
            return generatePHPFallback(jsonDescription: jsonDescription, className: className)
        default:
            return generateGenericFallback(jsonDescription: jsonDescription, className: className)
        }
    }
    
    private func generateSwiftFallback(jsonDescription: String, className: String) -> String {
        return """
        import Foundation

        struct \(className): Codable {
            // TODO: Add properties based on JSON structure
            // This is a fallback structure generated when AI is unavailable
            
            enum CodingKeys: String, CodingKey {
                // TODO: Add coding keys
            }
            
            init(from decoder: Decoder) throws {
                // TODO: Implement custom decoding
            }
            
            func encode(to encoder: Encoder) throws {
                // TODO: Implement custom encoding
            }
        }
        """
    }
    
    private func generateKotlinFallback(jsonDescription: String, className: String) -> String {
        return """
        data class \(className)(
            // TODO: Add properties based on JSON structure
            // This is a fallback structure generated when AI is unavailable
        ) {
            companion object {
                // TODO: Add companion object methods if needed
            }
        }
        """
    }
    
    private func generateJavaScriptFallback(jsonDescription: String, className: String) -> String {
        return """
        class \(className) {
            constructor(data = {}) {
                // TODO: Add properties based on JSON structure
                // This is a fallback structure generated when AI is unavailable
                Object.assign(this, data);
            }
            
            // TODO: Add methods as needed
        }
        
        export default \(className);
        """
    }
    
    private func generateTypeScriptFallback(jsonDescription: String, className: String) -> String {
        return """
        interface I\(className) {
            // TODO: Add properties based on JSON structure
            // This is a fallback structure generated when AI is unavailable
        }
        
        class \(className) implements I\(className) {
            constructor(data: I\(className) = {} as I\(className)) {
                Object.assign(this, data);
            }
            
            // TODO: Add methods as needed
        }
        
        export default \(className);
        """
    }
    
    private func generatePythonFallback(jsonDescription: String, className: String) -> String {
        return """
        from dataclasses import dataclass
        from typing import Optional, Any, Dict

        @dataclass
        class \(className):
            # TODO: Add properties based on JSON structure
            # This is a fallback structure generated when AI is unavailable
            
            def __init__(self, **kwargs):
                # TODO: Initialize properties from kwargs
                pass
            
            def to_dict(self) -> Dict[str, Any]:
                # TODO: Convert to dictionary
                return {}
            
            @classmethod
            def from_dict(cls, data: Dict[str, Any]) -> '\(className)':
                # TODO: Create instance from dictionary
                return cls()
        """
    }
    
    private func generateJavaFallback(jsonDescription: String, className: String) -> String {
        return """
        import com.fasterxml.jackson.annotation.JsonProperty;
        import java.util.Objects;

        public class \(className) {
            // TODO: Add properties based on JSON structure
            // This is a fallback structure generated when AI is unavailable
            
            public \(className)() {
                // Default constructor
            }
            
            // TODO: Add getters and setters
            
            @Override
            public boolean equals(Object o) {
                // TODO: Implement equals
                return super.equals(o);
            }
            
            @Override
            public int hashCode() {
                // TODO: Implement hashCode
                return super.hashCode();
            }
            
            @Override
            public String toString() {
                // TODO: Implement toString
                return super.toString();
            }
        }
        """
    }
    
    private func generateCSharpFallback(jsonDescription: String, className: String) -> String {
        return """
        using System;
        using System.Text.Json.Serialization;

        public class \(className)
        {
            // TODO: Add properties based on JSON structure
            // This is a fallback structure generated when AI is unavailable
            
            public \(className)()
            {
                // Default constructor
            }
            
            // TODO: Add properties with JsonPropertyName attributes
        }
        """
    }
    
    private func generateGoFallback(jsonDescription: String, className: String) -> String {
        return """
        package main

        import (
            "encoding/json"
            "fmt"
        )

        type \(className) struct {
            // TODO: Add fields based on JSON structure
            // This is a fallback structure generated when AI is unavailable
        }

        func (c *\(className)) MarshalJSON() ([]byte, error) {
            // TODO: Implement custom JSON marshaling
            return json.Marshal(c)
        }

        func (c *\(className)) UnmarshalJSON(data []byte) error {
            // TODO: Implement custom JSON unmarshaling
            return json.Unmarshal(data, c)
        }
        """
    }
    
    private func generateRustFallback(jsonDescription: String, className: String) -> String {
        return """
        use serde::{Deserialize, Serialize};

        #[derive(Debug, Serialize, Deserialize)]
        pub struct \(className) {
            // TODO: Add fields based on JSON structure
            // This is a fallback structure generated when AI is unavailable
        }

        impl \(className) {
            pub fn new() -> Self {
                // TODO: Implement constructor
                Self {}
            }
        }
        """
    }
    
    private func generatePHPFallback(jsonDescription: String, className: String) -> String {
        return """
        <?php

        class \(className)
        {
            // TODO: Add properties based on JSON structure
            // This is a fallback structure generated when AI is unavailable
            
            public function __construct(array $data = [])
            {
                // TODO: Initialize properties from data array
            }
            
            public function toArray(): array
            {
                // TODO: Convert to array
                return [];
            }
            
            public static function fromArray(array $data): self
            {
                // TODO: Create instance from array
                return new self($data);
            }
        }
        """
    }
    
    private func generateGenericFallback(jsonDescription: String, className: String) -> String {
        return """
        // \(className) - Generated Structure
        // This is a fallback structure generated when AI is unavailable
        // TODO: Implement proper structure for your programming language
        
        class \(className) {
            // TODO: Add properties based on JSON structure
            // TODO: Add methods as needed
        }
        """
    }
    
}
