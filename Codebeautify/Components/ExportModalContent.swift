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
        .frame(width: 500, height: 600)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 20)
        .onAppear {
            onAppear()
        }
    }
    
    // MARK: - View Sections
    private var headerSection: some View {
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
                    .background(fileExtensionBackground)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var fileExtensionBackground: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.gray.opacity(0.1))
    }
    
    private var languageSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Programming Language")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: languageGridColumns, spacing: 12) {
                ForEach(ExportLanguage.allCases, id: \.self) { language in
                    LanguageButton(
                        language: language,
                        isSelected: selectedLanguage == language,
                        action: {
                            selectedLanguage = language
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var codePreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Generated Code Preview")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            SyntaxHighlighter(code: exportOutput, language: selectedLanguage)
                .background(codePreviewBackground)
                .frame(maxHeight: 200)
        }
        .padding(.horizontal, 20)
    }
    
    private var codePreviewBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.customBackground)
            .overlay(codePreviewBorder)
    }
    
    private var codePreviewBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            Button("Cancel", action: onDismiss)
                .buttonStyle(.bordered)
            
            Spacer()
            
            Button(action: onCopy) {
                Label("Copy", systemImage: "doc.on.doc")
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
        .padding(.vertical, 16)
    }
    
    // MARK: - Computed Properties
    private var languageGridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 3)
    }
}
