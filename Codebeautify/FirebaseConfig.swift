//
//  FirebaseConfig.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import Foundation
import SwiftUI

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    private init() {}
    
    // MARK: - AI Services
    func generateText(prompt: String) async throws -> String {
        // For now, return a placeholder since Firebase AI is not working
        // This will trigger the fallback to local generation
        throw NSError(domain: "FirebaseAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase AI temporarily disabled"])
    }
    
    
    
    // MARK: - Code Generation with AI
    func generateCodeWithAI(jsonDescription: String, language: String, className: String) async throws -> String {
        // Temporarily disabled - will use local generation
        throw NSError(domain: "FirebaseAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "AI generation temporarily disabled"])
    }
    
}
