//
//  AIFeaturesView.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI
import FirebaseAI

struct AIFeaturesView: View {
    @StateObject private var firebaseManager = FirebaseManager.shared
    @Binding var jsonData: String
    @Binding var selectedLanguage: ExportLanguage
    @Binding var exportFileName: String
    @State private var aiGeneratedCode = ""
    @State private var isGenerating = false
    @State private var showAIFeatures = false
    @State private var selectedAIFeature: AIFeature = .generateCode
    @State private var showError = false
    @State private var errorMessage = ""
    
    enum AIFeature: String, CaseIterable {
        case generateCode = "Generate Code"
        case optimizeCode = "Optimize Code"
        case generateDocs = "Generate Documentation"
        
        var icon: String {
            switch self {
            case .generateCode: return "sparkles"
            case .optimizeCode: return "arrow.up.circle"
            case .generateDocs: return "doc.text"
            }
        }
        
        var description: String {
            switch self {
            case .generateCode: return "Generate code using AI"
            case .optimizeCode: return "Optimize existing code"
            case .generateDocs: return "Generate documentation"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // AI Features Button
            Button(action: { showAIFeatures = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .foregroundColor(.purple)
                    Text("AI Features")
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.purple.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)
            
            // AI Generated Code Preview
            if !aiGeneratedCode.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("AI Generated Code")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button("Use This Code") {
                            // Replace current code with AI generated code
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                    
                    SyntaxHighlighter(code: aiGeneratedCode, language: selectedLanguage)
                        .frame(maxHeight: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.windowBackgroundColor))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
        }
        .sheet(isPresented: $showAIFeatures) {
            AIFeaturesModal(
                selectedFeature: $selectedAIFeature,
                jsonData: jsonData,
                selectedLanguage: selectedLanguage,
                exportFileName: exportFileName,
                onCodeGenerated: { code in
                    aiGeneratedCode = code
                },
                isGenerating: $isGenerating,
                showError: $showError,
                errorMessage: $errorMessage
            )
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
}

struct AIFeaturesModal: View {
    @Binding var selectedFeature: AIFeaturesView.AIFeature
    let jsonData: String
    let selectedLanguage: ExportLanguage
    let exportFileName: String
    let onCodeGenerated: (String) -> Void
    @Binding var isGenerating: Bool
    @Binding var showError: Bool
    @Binding var errorMessage: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var firebaseManager = FirebaseManager.shared
    @State private var generatedCode = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Feature Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select AI Feature")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                        ForEach(AIFeaturesView.AIFeature.allCases, id: \.self) { feature in
                            Button(action: { selectedFeature = feature }) {
                                HStack(spacing: 12) {
                                    Image(systemName: feature.icon)
                                        .font(.title2)
                                        .foregroundColor(selectedFeature == feature ? .white : .purple)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(feature.rawValue)
                                            .font(.headline)
                                            .foregroundColor(selectedFeature == feature ? .white : .primary)
                                        
                                        Text(feature.description)
                                            .font(.caption)
                                            .foregroundColor(selectedFeature == feature ? .white.opacity(0.8) : .secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedFeature == feature {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedFeature == feature ? Color.purple : Color.gray.opacity(0.1))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Generate Button
                Button(action: generateWithAI) {
                    HStack(spacing: 8) {
                        if isGenerating {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "sparkles")
                        }
                        Text(isGenerating ? "Generating..." : "Generate with AI")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.purple)
                    )
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                }
                .disabled(isGenerating || jsonData.isEmpty)
                
                // Generated Code Preview
                if !generatedCode.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Generated Code")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        SyntaxHighlighter(code: generatedCode, language: selectedLanguage)
                            .frame(maxHeight: 300)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.windowBackgroundColor))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .navigationTitle("AI Features")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                if !generatedCode.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Use Code") {
                            onCodeGenerated(generatedCode)
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
    
    private func generateWithAI() {
        guard !jsonData.isEmpty else { return }
        
        isGenerating = true
        generatedCode = ""
        
        Task {
            do {
                let code: String
                
                switch selectedFeature {
                case .generateCode:
                    code = try await firebaseManager.generateCodeWithAI(
                        jsonDescription: jsonData,
                        language: selectedLanguage.rawValue,
                        className: exportFileName
                    )
                case .optimizeCode:
                    // First generate basic code, then optimize it
                    let basicCode = try await firebaseManager.generateCodeWithAI(
                        jsonDescription: jsonData,
                        language: selectedLanguage.rawValue,
                        className: exportFileName
                    )
                    code = try await firebaseManager.optimizeCode(
                        code: basicCode,
                        language: selectedLanguage.rawValue
                    )
                case .generateDocs:
                    let basicCode = try await firebaseManager.generateCodeWithAI(
                        jsonDescription: jsonData,
                        language: selectedLanguage.rawValue,
                        className: exportFileName
                    )
                    code = try await firebaseManager.generateDocumentation(
                        code: basicCode,
                        language: selectedLanguage.rawValue
                    )
                }
                
                await MainActor.run {
                    generatedCode = code
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isGenerating = false
                }
            }
        }
    }
}
