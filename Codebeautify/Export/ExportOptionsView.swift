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
        NavigationView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Export JSON to Code")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    // File Name Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("File Name")
                            .font(.headline)
                        HStack {
                            TextField("Enter file name", text: $exportFileName)
                                .textFieldStyle(.roundedBorder)
                            
                            Text(".\(selectedLanguage.fileExtension)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
                
                // Language Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Programming Language")
                        .font(.headline)
                    
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
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedLanguage == language ? Color.blue : Color.gray.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedLanguage == language ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Generated Code Preview
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Generated Code Preview")
                            .font(.headline)
                        Spacer()
                        HStack(spacing: 12) {
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
                    }
                    
                    ScrollView {
                        Text(exportOutput)
                            .font(.system(.body, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding()
                    }
                    .background(Color.customBackground)
                    .cornerRadius(8)
                    .frame(maxHeight: 250)
                }
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Export Code")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
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
