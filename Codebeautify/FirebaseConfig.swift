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
    private var isConfigured = false
    
    private init() {
        configureFirebase()
    }
    
    private func configureFirebase() {
        // Configure Firebase only if not already configured
        guard !isConfigured else {
            print("Firebase already configured")
            return
        }
        
        // Check if Firebase is already configured by another part of the app
        if FirebaseApp.app() != nil {
            print("Firebase already configured by another component")
            isConfigured = true
            return
        }
        
        FirebaseApp.configure()
        isConfigured = true
        print("Firebase configured successfully")
    }
    
    // MARK: - AI Services
    func getGenerativeModel() -> GenerativeModel? {
        // Check if Firebase is properly configured
        guard FirebaseApp.app() != nil else {
            print("Error: Firebase not configured")
            return nil
        }
        
        do {
            let ai = FirebaseAI.firebaseAI(backend: .googleAI())
            let model = ai.generativeModel(modelName: "gemini-2.5-flash")
            print("Generative model created successfully")
            return model
        } catch {
            print("Error creating generative model: \(error.localizedDescription)")
            print("Error details: \(error)")
            return nil
        }
    }
    
    // MARK: - Text Generation
    func generateText(prompt: String) async throws -> String {
        guard let model = getGenerativeModel() else {
            throw NSError(domain: "FirebaseAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create generative model"])
        }
        
        do {
            print("Generating text with prompt: \(prompt.prefix(100))...")
            let response = try await model.generateContent(prompt)
            let result = response.text ?? "No response generated"
            print("Text generation completed successfully")
            return result
        } catch {
            print("Error in generateText: \(error.localizedDescription)")
            print("Error type: \(type(of: error))")
            print("Error details: \(error)")
            
            // Check for specific network errors
            if let nsError = error as NSError? {
                if nsError.domain == "NSURLErrorDomain" && nsError.code == -1003 {
                    print("Network error: Server hostname could not be found")
                    print("This usually indicates a network connectivity issue or DNS problem")
                }
            }
            
            throw error
        }
    }
    
    // MARK: - Configuration Check
    func isFirebaseConfigured() -> Bool {
        return FirebaseApp.app() != nil
    }
    
    func checkFirebaseConfiguration() -> String {
        if isFirebaseConfigured() {
            return "Firebase is properly configured"
        } else {
            return "Firebase is NOT configured"
        }
    }
    
    // MARK: - Code Generation with AI
    func generateCodeWithAI(jsonDescription: String, language: String, className: String) async throws -> String {
        print("Starting AI code generation...")
        print("Language: \(language)")
        print("ClassName: \(className)")
        print("JSON Description length: \(jsonDescription.count)")
        print("Firebase status: \(checkFirebaseConfiguration())")
        
        let prompt = """
        Generate a \(language) class/struct named \(className) based on this JSON structure:
        
        \(jsonDescription)
        
        Requirements:
        - Use proper \(language) syntax and conventions
        - Include appropriate imports/dependencies
        - Add proper type annotations
        - Follow \(language) naming conventions
        - Make it production-ready code
        
        Return only the code, no explanations.
        """
        
        print("Prompt created, length: \(prompt.count)")
        return try await generateText(prompt: prompt)
    }
    
    // MARK: - Code Optimization
    func optimizeCode(code: String, language: String) async throws -> String {
        let prompt = """
        Optimize this \(language) code for better performance, readability, and maintainability:
        
        \(code)
        
        Requirements:
        - Keep the same functionality
        - Improve performance where possible
        - Enhance readability
        - Follow best practices
        - Add comments where helpful
        
        Return only the optimized code.
        """
        
        return try await generateText(prompt: prompt)
    }
    
    // MARK: - Code Documentation
    func generateDocumentation(code: String, language: String) async throws -> String {
        let prompt = """
        Generate comprehensive documentation for this \(language) code:
        
        \(code)
        
        Include:
        - Class/struct documentation
        - Method/function documentation
        - Parameter descriptions
        - Return value descriptions
        - Usage examples
        - Follow \(language) documentation standards
        
        Return only the documentation.
        """
        
        return try await generateText(prompt: prompt)
    }
}
