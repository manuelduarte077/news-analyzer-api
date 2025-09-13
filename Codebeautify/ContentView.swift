//
//  ContentView.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI
import Foundation

// MARK: - Main View
struct ContentView: View {
    @State private var selectedTool: ToolType?
    var body: some View {
        NavigationSplitView {
            // Sidebar
            VStack(spacing: 0) {
                // Tools List
                List(ToolType.allCases, id: \.self, selection: $selectedTool) { tool in
                    Label(tool.rawValue, systemImage: tool.icon)
                        .tag(tool as ToolType?)
                }
                .navigationTitle("Codebeautify")
                
                Divider()
                
                // Developer Info Section
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
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "envelope.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .frame(width: 12)
                            Text("dev@donmanuel.com")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "globe")
                                .font(.caption)
                                .foregroundColor(.green)
                                .frame(width: 12)
                            Text("donmanuel.dev")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "app.badge")
                                .font(.caption)
                                .foregroundColor(.orange)
                                .frame(width: 12)
                            Text("Version 1.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.customSecondaryBackground)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            // Detail view
            if let tool = selectedTool {
                ToolDetailView(selectedTool: tool)
                    .id(tool)
            } else {
                Text("Select a tool")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

//MARK: - Detail view
struct ToolDetailView: View {
    let selectedTool: ToolType
    @AppStorage("viewMode") private var viewMode: ViewMode = .text
    @State private var inputText: String = ""
    @State private var outputText: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var jsonNodes: [JSONNode] = []
    @State private var showCopiedAlert: Bool = false
    @State private var selectedExportLanguage: ExportLanguage = .swift
    @State private var showExportOptions: Bool = false
    @State private var exportOutput: String = ""
    @State private var exportFileName: String = "GeneratedModel"
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            VStack(spacing: 12) {
                HStack {
                    Text(selectedTool.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Mode Picker
                    if selectedTool == .jsonFormatter {
                        Picker("View Mode", selection: $viewMode) {
                            ForEach(ViewMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                }
                
                HStack {
                    Button(action: onClickClear) {
                        Label("Clear", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                    .disabled(inputText.isEmpty)
                    
                    Button(action: onClickCopy) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.bordered)
                    .disabled(outputText.isEmpty)
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color.customToolbarBackground)
            
            Divider()
            
            // Content area
            if selectedTool == .jsonFormatter && viewMode == .tree && !jsonNodes.isEmpty {
                // Tree view for JSON
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(jsonNodes) { node in
                            JSONTreeNodeView(node: node, level: 0)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.customBackground)
            } else {
                // Text-based view
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Input")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            TextEditor(text: $inputText)
                                .font(.system(.body, design: .monospaced))
                                .padding(4)
                                .background(Color.customBackground)
                                .cornerRadius(8)
                                .padding(.horizontal)
                                .onChange(of: inputText) { _, newValue in
                                    // Save input to UserDefaults
                                    UserDefaults.standard.set(newValue, forKey: selectedTool.storageKey)
                                    processInput()
                                }
                        }
                        .frame(height: geometry.size.height / 2)
                        .background(Color.customSecondaryBackground)
                        
                        Divider()
                        
                        // Output
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Output")
                                    .font(.headline)
                                
                                Spacer()
                                
                                if selectedTool == .jsonFormatter && !outputText.isEmpty {
                                    Button(action: { showExportOptions = true }) {
                                        Label("Export", systemImage: "square.and.arrow.up")
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            
                            ScrollView {
                                if isCodeOutput(outputText) {
                                    SyntaxHighlighter(code: outputText, language: detectLanguage(outputText))
                                } else {
                                    Text(outputText)
                                        .font(.system(.body, design: .monospaced))
                                        .textSelection(.enabled)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        .padding()
                                }
                            }
                            .background(Color.customBackground)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        .frame(height: geometry.size.height / 2)
                        .background(Color.customSecondaryBackground)
                    }
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .alert("Copied!", isPresented: $showCopiedAlert) {
            Button("OK") { }
        } message: {
            Text("Output copied to clipboard")
        }
        .sheet(isPresented: $showExportOptions) {
            ExportOptionsView(
                selectedLanguage: $selectedExportLanguage,
                exportOutput: $exportOutput,
                exportFileName: $exportFileName,
                jsonData: outputText
            )
        }
        .onAppear {
            // Load saved input from UserDefaults
            inputText = UserDefaults.standard.string(forKey: selectedTool.storageKey) ?? ""
            processInput()
        }
    }
    
    // MARK: - Actions
    func onClickClear() {
        inputText = ""
        outputText = ""
        jsonNodes = []
        UserDefaults.standard.removeObject(forKey: selectedTool.storageKey)
    }
    
    func onClickCopy() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(outputText, forType: .string)
        showCopiedAlert = true
    }
    
    func processInput() {
        guard !inputText.isEmpty else {
            outputText = ""
            jsonNodes = []
            return
        }
        
        switch selectedTool {
        case .jsonFormatter:
            formatJSON()
        }
    }
    
    // MARK: - JSON Formatter
    func formatJSON() {
        do {
            guard let data = inputText.data(using: .utf8) else {
                throw NSError(domain: "Invalid input", code: 0)
            }
            
            let json = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
            outputText = String(data: prettyData, encoding: .utf8) ?? ""
            
            // Parse for tree view
            jsonNodes = parseJSONToNodes(json: json, key: nil)
        } catch {
            outputText = "Invalid JSON: \(error.localizedDescription)"
            jsonNodes = []
        }
    }
    
    func parseJSONToNodes(json: Any, key: String?) -> [JSONNode] {
        if let dict = json as? [String: Any] {
            let node = JSONNode(key: key, value: dict, type: .dictionary, children: dict.compactMap { k, v in
                parseJSONToNodes(json: v, key: k).first
            })
            return [node]
        } else if let array = json as? [Any] {
            let node = JSONNode(key: key, value: array, type: .array, children: array.enumerated().compactMap { index, item in
                parseJSONToNodes(json: item, key: "[\(index)]").first
            })
            return [node]
        } else if let string = json as? String {
            return [JSONNode(key: key, value: string, type: .string)]
        } else if let number = json as? NSNumber {
            if number.isBool {
                return [JSONNode(key: key, value: number.boolValue, type: .boolean)]
            } else {
                return [JSONNode(key: key, value: number, type: .number)]
            }
        } else if json is NSNull {
            return [JSONNode(key: key, value: "null", type: .null)]
        }
        return []
        }
        
    }
    
    // MARK: - Code Detection
    private func isCodeOutput(_ text: String) -> Bool {
        // Check if the output looks like generated code
        let codeIndicators = [
            "import ", "class ", "struct ", "interface ", "function ", "public class",
            "<?php", "using ", "namespace ", "export ", "interface ", "type ",
            "data class", "object ", "enum ", "protocol ", "extension "
        ]
        
        return codeIndicators.contains { text.contains($0) }
    }
    
    private func detectLanguage(_ text: String) -> ExportLanguage {
        // Swift indicators
        if text.contains("import Foundation") || text.contains("struct ") || text.contains(": Codable") {
            return .swift
        }
        
        // Kotlin indicators
        if text.contains("data class") || text.contains("import com.google.gson") {
            return .kotlin
        }
        
        // Java indicators
        if text.contains("public class") && text.contains("import com.google.gson") {
            return .java
        }
        
        // C# indicators
        if text.contains("using System") || text.contains("using Newtonsoft") {
            return .csharp
        }
        
        // TypeScript indicators
        if text.contains("export interface") || text.contains(": string") || text.contains(": number") {
            return .typescript
        }
        
        // JavaScript indicators
        if text.contains("class ") && text.contains("module.exports") {
            return .javascript
        }
        
        // Dart indicators
        if text.contains("class ") && text.contains("final ") && text.contains("required this") {
            return .dart
        }
        
        // Objective-C indicators
        if text.contains("#import") && text.contains("@interface") {
            return .objectivec
        }
        
        // PHP indicators
        if text.contains("<?php") || text.contains("class ") && text.contains("public $") {
            return .php
        }
        
        // Default to Swift if no specific language detected
        return .swift
    }
    
    // MARK: - Extensions
extension NSNumber {
    var isBool: Bool {
        CFBooleanGetTypeID() == CFGetTypeID(self)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
