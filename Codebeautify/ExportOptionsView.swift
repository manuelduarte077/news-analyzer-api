//
//  ExportOptionsView.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct ExportOptionsView: View {
    @Binding var selectedLanguage: ExportLanguage
    @Binding var exportOutput: String
    @Binding var exportFileName: String
    let jsonData: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var showCopiedAlert = false
    @State private var showSaveDialog = false
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("AI Generated Code")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "sparkles")
                            .foregroundColor(.purple)
                            .font(.caption)
                    }
                    
                    Text("\(selectedLanguage.rawValue) • \(exportOutput.components(separatedBy: .newlines).count) lines")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    // Code Preview
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Code Preview")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button("Copy") {
                                copyCode()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                        
                        SyntaxHighlighter(code: exportOutput, language: selectedLanguage)
                            .frame(maxHeight: 400)
                            .background(Color(.textBackgroundColor))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.horizontal, 20)
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        Button("Copy Code") {
                            copyCode()
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                        
                        Button("Save to File") {
                            showSaveDialog = true
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
            }
        }
        .frame(width: 600, height: 500)
        .background(Color(.windowBackgroundColor))
        .alert("Copied!", isPresented: $showCopiedAlert) {
            Button("OK") { }
        } message: {
            Text("Code copied to clipboard")
        }
        .alert("Save Error", isPresented: $showSaveError) {
            Button("OK") { }
        } message: {
            Text("Failed to save file: \(saveErrorMessage)")
        }
        .fileExporter(
            isPresented: $showSaveDialog,
            document: CodeDocument(content: exportOutput),
            contentType: getContentType(for: selectedLanguage),
            defaultFilename: "\(exportFileName).\(selectedLanguage.fileExtension)"
        ) { result in
            handleSaveResult(result)
        }
    }
    
    // MARK: - Actions
    private func copyCode() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(exportOutput, forType: .string)
        showCopiedAlert = true
    }
    
    private func getContentType(for language: ExportLanguage) -> UTType {
        switch language {
        case .swift:
            return UTType(filenameExtension: "swift") ?? UTType.plainText
        case .kotlin:
            return UTType(filenameExtension: "kt") ?? UTType.plainText
        case .java:
            return UTType(filenameExtension: "java") ?? UTType.plainText
        case .csharp:
            return UTType(filenameExtension: "cs") ?? UTType.plainText
        case .typescript:
            return UTType(filenameExtension: "ts") ?? UTType.plainText
        case .javascript:
            return UTType(filenameExtension: "js") ?? UTType.plainText
        case .objectivec:
            return UTType(filenameExtension: "h") ?? UTType.plainText
        }
    }
    
    private func handleSaveResult(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            print("File saved successfully to: \(url)")
        case .failure(let error):
            print("Error saving file: \(error.localizedDescription)")
            saveErrorMessage = error.localizedDescription
            showSaveError = true
        }
    }
}

// MARK: - Preview
#Preview {
    ExportOptionsView(
        selectedLanguage: .constant(.swift),
        exportOutput: .constant("struct SampleModel: Codable {\n    let id: Int\n    let name: String\n}"),
        exportFileName: .constant("SampleModel"),
        jsonData: "{\"id\": 1, \"name\": \"Test\"}"
    )
}