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
        ExportModalContent(
            selectedLanguage: $selectedLanguage,
            exportOutput: $exportOutput,
            exportFileName: $exportFileName,
            onCopy: copyExport,
            onSave: { showSaveDialog = true },
            onDismiss: { dismiss() },
            onAppear: generateExport
        )
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
}
