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
    
    // MARK: - Computed Properties
    private var languageGridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 3)
    }
}
