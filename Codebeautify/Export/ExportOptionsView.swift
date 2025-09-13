//
//  ExportOptionsView.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI
import Foundation

struct ExportOptionsView: View {
    @Binding var selectedLanguage: ExportLanguage
    @Binding var exportOutput: String
    @Binding var exportFileName: String
    let jsonData: String
    @Environment(\.dismiss) private var dismiss
    @State private var showCopiedAlert = false
    @State private var showSaveDialog = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("Export...")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    // File Name Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("File Name")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 8) {
                            TextField("test", text: $exportFileName)
                                .textFieldStyle(.roundedBorder)
                                .font(.system(.body, design: .monospaced))
                            
                            Text(".\(selectedLanguage.fileExtension)")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Language Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Programming Language")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            ForEach(ExportLanguage.allCases, id: \.self) { language in
                                Button(action: {
                                    selectedLanguage = language
                                    generateExport()
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: language.icon)
                                            .font(.title2)
                                            .foregroundColor(selectedLanguage == language ? .white : .blue)
                                        
                                        Text(language.rawValue)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(selectedLanguage == language ? .white : .primary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedLanguage == language ? Color.blue : Color.gray.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(selectedLanguage == language ? Color.blue : Color.clear, lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Generated Code Preview
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Generated Code Preview")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        ScrollView {
                            Text(exportOutput)
                                .font(.system(.caption, design: .monospaced))
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(12)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.customBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .frame(maxHeight: 200)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
            }
            
            Divider()
            
            // Action Buttons
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button(action: copyExport) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
                .buttonStyle(.bordered)
                .disabled(exportOutput.isEmpty)
                
                Button(action: { showSaveDialog = true }) {
                    Label("Save File", systemImage: "square.and.arrow.down")
                }
                .buttonStyle(.borderedProminent)
                .disabled(exportOutput.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .frame(width: 500, height: 600)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 20)
        .alert("Copied!", isPresented: $showCopiedAlert) {
            Button("OK") { }
        } message: {
            Text("Code copied to clipboard")
        }
        .fileExporter(
            isPresented: $showSaveDialog,
            document: CodeDocument(content: exportOutput),
            contentType: .plainText,
            defaultFilename: "\(exportFileName).\(selectedLanguage.fileExtension)"
        ) { result in
            switch result {
            case .success(let url):
                print("File saved to: \(url)")
            case .failure(let error):
                print("Error saving file: \(error)")
            }
        }
        .onAppear {
            generateExport()
        }
    }
    
    private func generateExport() {
        guard let data = jsonData.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) else {
            exportOutput = "Invalid JSON data"
            return
        }
        
        exportOutput = CodeGenerator.generateCodeForLanguage(json: json, language: selectedLanguage, className: exportFileName)
    }
    
    private func copyExport() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(exportOutput, forType: .string)
        showCopiedAlert = true
    }
}
