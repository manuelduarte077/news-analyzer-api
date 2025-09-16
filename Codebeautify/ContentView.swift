//
//  ContentView.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var inputJSON: String = ""
    @State private var selectedLanguage: ExportLanguage = .swift
    @State private var className: String = "GeneratedModel"
    @State private var generatedCode: String = ""
    @State private var showExportOptions = false
    @State private var showCopiedAlert = false
    @State private var isGenerating = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(.purple)
                    
                    Text("Codebeautify")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("AI-Powered Code Generator")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                Divider()
                
                // Language Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Programming Language")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(ExportLanguage.allCases, id: \.self) { language in
                            Label(language.rawValue, systemImage: language.icon)
                                .tag(language)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, 20)
                    .onChange(of: selectedLanguage) { _, _ in
                        generateCodeWithAI()
                    }
                }
                .padding(.vertical, 16)
                
                Divider()
                
                // Class Name Input
                VStack(alignment: .leading, spacing: 12) {
                    Text("Class Name")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    TextField("Enter class name", text: $className)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 20)
                        .onChange(of: className) { _, _ in
                            generateCodeWithAI()
                        }
                }
                .padding(.vertical, 16)
                
                Divider()
                
                // AI Features Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("AI-Powered Features")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "sparkles")
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        Button(action: generateCodeWithAI) {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                Text("Generate with AI")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.purple.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .foregroundColor(.purple)
                            .fontWeight(.medium)
                        }
                        .buttonStyle(.plain)
                        .disabled(inputJSON.isEmpty || isGenerating)
                        
                        
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
                
                Spacer()
                
                // Developer Info
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "person.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Manuel Duarte")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text("iOS Developer")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
            .frame(minWidth: 280)
            .background(Color(.controlBackgroundColor))
            
        } detail: {
            // Main Content
            VStack(spacing: 0) {
                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("JSON Input")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Clear") {
                            inputJSON = ""
                            generatedCode = ""
                        }
                        .buttonStyle(.bordered)
                        .disabled(inputJSON.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    TextEditor(text: $inputJSON)
                        .font(.system(.body, design: .monospaced))
                        .padding(12)
                        .background(Color(.textBackgroundColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .onChange(of: inputJSON) { _, _ in
                            // Auto-generate when JSON changes
                            if !inputJSON.isEmpty && !className.isEmpty {
                                generateCodeWithAI()
                            }
                        }
                }
                .frame(maxHeight: 300)
                
                Divider()
                
                // Output Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text("AI Generated Code")
                                    .font(.headline)
                                
                                Image(systemName: "sparkles")
                                    .foregroundColor(.purple)
                                    .font(.caption)
                            }
                            
                            if isGenerating {
                                HStack(spacing: 8) {
                                    ProgressView()
                                        .controlSize(.small)
                                    Text("Generating with AI...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            } else {
                                Text("\(selectedLanguage.rawValue) • \(generatedCode.components(separatedBy: .newlines).count) lines")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Button("Copy") {
                                copyCode()
                            }
                            .buttonStyle(.bordered)
                            .disabled(generatedCode.isEmpty)
                            
                            Button("Export") {
                                showExportOptions = true
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(generatedCode.isEmpty)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    if generatedCode.isEmpty && !isGenerating {
                        VStack(spacing: 16) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 32))
                                .foregroundColor(.purple.opacity(0.5))
                            VStack(spacing: 8) {
                                Text("No AI code generated")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Enter JSON to generate code with AI")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        SyntaxHighlighter(code: generatedCode, language: selectedLanguage)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .alert("Copied!", isPresented: $showCopiedAlert) {
            Button("OK") { }
        } message: {
            Text("Code copied to clipboard")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showExportOptions) {
            ExportOptionsView(
                selectedLanguage: $selectedLanguage,
                exportOutput: $generatedCode,
                exportFileName: $className,
                jsonData: inputJSON
            )
        }
        .onAppear {
            loadSampleJSON()
        }
    }
    
    // MARK: - AI Actions
    private func generateCodeWithAI() {
        guard !inputJSON.isEmpty, !className.isEmpty else {
            generatedCode = ""
            return
        }
        
        guard let data = inputJSON.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) else {
            errorMessage = "Invalid JSON format"
            showError = true
            return
        }
        
        isGenerating = true
        
        Task {
            do {
                let firebaseManager = FirebaseManager.shared
                let aiGeneratedCode = try await firebaseManager.generateCodeWithAI(
                    jsonDescription: inputJSON,
                    language: selectedLanguage.rawValue,
                    className: className
                )
                
                await MainActor.run {
                    generatedCode = aiGeneratedCode
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    // Fallback to local generation
                    generatedCode = generateFallbackCode(json: json)
                    isGenerating = false
                    
                    errorMessage = "AI generation failed, using local generator: \(error.localizedDescription)"
                    
                    showError = true
                }
            }
        }
    }
    
    
    private func generateFallbackCode(json: Any) -> String {
        let fallbackCode = CodeGenerator.generateCodeForLanguage(
            json: json,
            language: selectedLanguage,
            className: className
        )
        
        let fallbackMessage = """
        // Generated using local method (AI unavailable)
        // This code is fully functional and ready to use
        //
        
        """
        
        return fallbackMessage + fallbackCode
    }
    
    private func copyCode() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(generatedCode, forType: .string)
        showCopiedAlert = true
    }
    
    private func loadSampleJSON() {
        inputJSON = """
        {
            "id": 1,
            "name": "Sample User",
            "email": "user@example.com",
            "isActive": true,
            "profile": {
                "firstName": "John",
                "lastName": "Doe",
                "age": 30
            },
            "tags": ["developer", "swift", "ios"]
        }
        """
        // Auto-generate sample code
        generateCodeWithAI()
    }
    
}

// MARK: - Preview
#Preview {
    ContentView()
}