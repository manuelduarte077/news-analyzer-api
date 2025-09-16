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
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        return ai.generativeModel(modelName: "gemini-2.5-flash")
    }
    
    func generateText(prompt: String) async throws -> String {
        guard let model = getGenerativeModel() else {
            throw NSError(domain: "FirebaseAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create generative model"])
        }
        
        let response = try await model.generateContent(prompt)
        return response.text ?? "No response generated"
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
        
        Return only the code, no explanations.
        """
        
        return try await generateText(prompt: prompt)
    }
    
}
