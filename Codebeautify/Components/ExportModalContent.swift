//
//  ExportModalContent.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI

// MARK: - Export Modal Content
struct ExportModalContent: View {
    @Binding var selectedLanguage: ExportLanguage
    @Binding var exportOutput: String
    @Binding var exportFileName: String
    let jsonData: String
    
    let onCopy: () -> Void
    let onSave: () -> Void
    let onDismiss: () -> Void
    let onAppear: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Divider()
            contentSection
            Divider()
            actionButtonsSection
        }
        .frame(width: 700, height: 700)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 20)
        .onAppear {
            onAppear()
        }
    }
    
    // MARK: - View Sections
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Export JSON to Code")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Generate type-safe code models from your JSON data")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Language indicator
            HStack {
                Image(systemName: selectedLanguage.icon)
                    .foregroundColor(.blue)
                Text("Selected: \(selectedLanguage.rawValue)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    private var contentSection: some View {
        ScrollView {
            VStack(spacing: 20) {
                fileNameSection
                languageSelectionSection
                aiFeaturesSection
                codePreviewSection
            }
            .padding(.vertical, 16)
        }
    }
    
    private var fileNameSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("File Name")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                TextField("GeneratedModel", text: $exportFileName)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
                    .onChange(of: exportFileName) { _, _ in
                        // Trigger regeneration when file name changes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onAppear()
                        }
                    }
                
                Text(".\(selectedLanguage.fileExtension)")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(fileExtensionBackground)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        )
        .padding(.horizontal, 20)
    }
    
    private var fileExtensionBackground: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.gray.opacity(0.1))
    }
    
    private var languageSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Select Programming Language")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(ExportLanguage.allCases.count) languages available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: languageGridColumns, spacing: 12) {
                ForEach(ExportLanguage.allCases, id: \.self) { language in
                    LanguageButton(
                        language: language,
                        isSelected: selectedLanguage == language,
                        action: {
                            selectedLanguage = language
                            // Trigger regeneration when language changes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                onAppear()
                            }
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal, 20)
    }
    
    private var aiFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("AI-Powered Features")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .foregroundColor(.purple)
            }
            
            HStack(spacing: 12) {
                Button(action: generateWithAI) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                        Text("Generate with AI")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
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
                .disabled(jsonData.isEmpty)
                
                Button(action: optimizeWithAI) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.circle")
                        Text("Optimize")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                }
                .buttonStyle(.plain)
                .disabled(exportOutput.isEmpty)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal, 20)
    }
    
    private var codePreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Generated Code Preview")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(selectedLanguage.rawValue) • \(exportOutput.components(separatedBy: .newlines).count) lines")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: onCopy) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.bordered)
                    .disabled(exportOutput.isEmpty)
                    .controlSize(.small)
                }
            }
            
            ZStack {
                if exportOutput.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 32))
                            .foregroundColor(.gray.opacity(0.5))
                        VStack(spacing: 8) {
                            Text("No code generated")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Select a language to generate code")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxHeight: 250)
                } else {
                    SyntaxHighlighter(code: exportOutput, language: selectedLanguage)
                        .frame(maxHeight: 250)
                }
            }
            .background(codePreviewBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        )
        .padding(.horizontal, 20)
    }
    
    private var codePreviewBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.windowBackgroundColor))
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            Button("Cancel", action: onDismiss)
                .buttonStyle(.bordered)
            
            Spacer()
            
            Button(action: onCopy) {
                Label("Copy Code", systemImage: "doc.on.doc")
            }
            .buttonStyle(.bordered)
            .disabled(exportOutput.isEmpty)
            
            Button(action: onSave) {
                Label("Save File", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
            .disabled(exportOutput.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.windowBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - AI Functions
    private func generateWithAI() {
        guard !jsonData.isEmpty else { 
            print("JSON data is empty")
            return 
        }
        
        print("Starting AI code generation...")
        
        Task {
            do {
                let firebaseManager = FirebaseManager.shared
                print("Firebase manager created, generating code...")
                
                // Check Firebase configuration first
                print("Firebase configuration status: \(firebaseManager.checkFirebaseConfiguration())")
                
                let aiGeneratedCode = try await firebaseManager.generateCodeWithAI(
                    jsonDescription: jsonData,
                    language: selectedLanguage.rawValue,
                    className: exportFileName
                )
                
                print("AI code generation completed successfully")
                
                await MainActor.run {
                    exportOutput = aiGeneratedCode
                    print("Export output updated with AI generated code")
                }
            } catch {
                print("Error generating code with AI: \(error.localizedDescription)")
                print("Error type: \(type(of: error))")
                
                // Determine error type for better user feedback
                let errorType = determineErrorType(error)
                print("Detected error type: \(errorType)")
                
                // Fallback to local code generation
                await MainActor.run {
                    exportOutput = generateFallbackCode(with: errorType)
                }
            }
        }
    }
    
    private func determineErrorType(_ error: Error) -> String {
        if let nsError = error as NSError? {
            switch (nsError.domain, nsError.code) {
            case ("NSURLErrorDomain", -1003):
                return "Network connectivity issue - server hostname could not be found"
            case ("NSURLErrorDomain", -1001):
                return "Request timeout - server took too long to respond"
            case ("NSURLErrorDomain", -1009):
                return "No internet connection available"
            case ("NSURLErrorDomain", -1200):
                return "SSL/TLS connection error"
            case ("FirebaseAI", _):
                return "Firebase AI service error"
            default:
                return "Unknown error: \(nsError.localizedDescription)"
            }
        }
        return "Unknown error: \(error.localizedDescription)"
    }
    
    private func generateFallbackCode(with errorType: String = "Unknown error") -> String {
        print("Using fallback code generation...")
        
        guard let data = jsonData.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) else {
            return "// Error: Invalid JSON data"
        }
        
        let fallbackCode = CodeGenerator.generateCodeForLanguage(
            json: json, 
            language: selectedLanguage, 
            className: exportFileName
        )
        
        let fallbackMessage = """
        // Generated using local method (Firebase AI unavailable)
        // Reason: \(errorType)
        // This code is fully functional and ready to use
        // 
        // Troubleshooting steps:
        // 1. Check your internet connection
        // 2. Verify DNS settings
        // 3. Try disabling VPN or proxy if active
        // 4. Check Firebase Console for service status
        // 5. Verify your Firebase project configuration
        //
        
        """
        
        return fallbackMessage + fallbackCode
    }
    
    private func optimizeWithAI() {
        guard !exportOutput.isEmpty else { 
            print("Export output is empty, cannot optimize")
            return 
        }
        
        print("Starting AI code optimization...")
        
        Task {
            do {
                let firebaseManager = FirebaseManager.shared
                print("Firebase manager created, optimizing code...")
                
                let optimizedCode = try await firebaseManager.optimizeCode(
                    code: exportOutput,
                    language: selectedLanguage.rawValue
                )
                
                print("AI code optimization completed successfully")
                
                await MainActor.run {
                    exportOutput = optimizedCode
                    print("Export output updated with optimized code")
                }
            } catch {
                print("Error optimizing code with AI: \(error.localizedDescription)")
                await MainActor.run {
                    exportOutput = "Error optimizing code with AI: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    private var languageGridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 3)
    }
}
