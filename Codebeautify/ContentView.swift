//
//  ContentView.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI
import Foundation


enum ViewMode: String, CaseIterable {
    case text = "Text View"
    case tree = "Tree View"
}

enum ProcessMode: String, CaseIterable {
    case encode = "Encode"
    case decode = "Decode"
}

enum ExportLanguage: String, CaseIterable {
    case java = "Java"
    case kotlin = "Kotlin"
    case csharp = "C#"
    case swift = "Swift"
    case objectivec = "Objective-C"
    case dart = "Dart"
    case typescript = "TypeScript"
    case javascript = "JavaScript"
    case php = "PHP"
    
    var fileExtension: String {
        switch self {
        case .java: return "java"
        case .kotlin: return "kt"
        case .csharp: return "cs"
        case .swift: return "swift"
        case .objectivec: return "h"
        case .dart: return "dart"
        case .typescript: return "ts"
        case .javascript: return "js"
        case .php: return "php"
        }
    }
    
    var icon: String {
        switch self {
        case .java: return "cup.and.saucer"
        case .kotlin: return "k.circle"
        case .csharp: return "c.circle"
        case .swift: return "swift"
        case .objectivec: return "o.circle"
        case .dart: return "d.circle"
        case .typescript: return "t.circle"
        case .javascript: return "j.circle"
        case .php: return "p.circle"
        }
    }
}

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
                    
                    // Contact information
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
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)
            #endif
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
        #if os(macOS)
        .navigationSplitViewStyle(.balanced)
        #endif
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
                    
                    if selectedTool == .jsonFormatter && !outputText.isEmpty {
                        Button(action: { showExportOptions = true }) {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.bordered)
                    }
                    
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
                            Text("Output")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            ScrollView {
                                Text(outputText)
                                    .font(.system(.body, design: .monospaced))
                                    .textSelection(.enabled)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .padding()
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
        case .jwt:
            decodeJWT()
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
    
    // MARK: - JWT Decoder
    func decodeJWT() {
        let parts = inputText.split(separator: ".")
        guard parts.count == 3 else {
            outputText = "Invalid JWT format"
            return
        }
        
        var result = "=== JWT Decoded ===\n\n"
        
        // Decode header
        if let header = decodeJWTPart(String(parts[0])) {
            result += "Header:\n\(header)\n\n"
        }
        
        // Decode payload
        if let payload = decodeJWTPart(String(parts[1])) {
            result += "Payload:\n\(payload)\n\n"
        }
        
        result += "Signature:\n\(parts[2])"
        
        outputText = result
    }
    
    func decodeJWTPart(_ part: String) -> String? {
        var base64 = part
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }
        
        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        
        return prettyString
    }
    
}


// MARK: - Extensions
extension NSNumber {
    var isBool: Bool {
        CFBooleanGetTypeID() == CFGetTypeID(self)
    }
}



// MARK: - Export Options View
struct ExportOptionsView: View {
    @Binding var selectedLanguage: ExportLanguage
    @Binding var exportOutput: String
    let jsonData: String
    @Environment(\.dismiss) private var dismiss
    @State private var showCopiedAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Language Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Language")
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
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedLanguage == language ? Color.blue : Color.gray.opacity(0.1))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Export Output
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Generated Code")
                            .font(.headline)
                        Spacer()
                        Button(action: copyExport) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                        .buttonStyle(.bordered)
                        .disabled(exportOutput.isEmpty)
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
                    .frame(maxHeight: 300)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Export to \(selectedLanguage.rawValue)")
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
        
        exportOutput = generateCodeForLanguage(json: json, language: selectedLanguage)
    }
    
    private func copyExport() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(exportOutput, forType: .string)
        showCopiedAlert = true
    }
}

// MARK: - Code Generation Logic
func generateCodeForLanguage(json: Any, language: ExportLanguage) -> String {
    let className = "GeneratedModel"
    
    switch language {
    case .swift:
        return generateSwiftCode(json: json, className: className)
    case .kotlin:
        return generateKotlinCode(json: json, className: className)
    case .java:
        return generateJavaCode(json: json, className: className)
    case .csharp:
        return generateCSharpCode(json: json, className: className)
    case .typescript:
        return generateTypeScriptCode(json: json, className: className)
    case .javascript:
        return generateJavaScriptCode(json: json, className: className)
    case .dart:
        return generateDartCode(json: json, className: className)
    case .objectivec:
        return generateObjectiveCCode(json: json, className: className)
    case .php:
        return generatePHPCode(json: json, className: className)
    }
}

// MARK: - Swift Code Generation
func generateSwiftCode(json: Any, className: String) -> String {
    var code = "import Foundation\n\n"
    code += "struct \(className): Codable {\n"
    
    if let dict = json as? [String: Any] {
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            let type = getSwiftType(value)
            code += "    let \(propertyName): \(type)\n"
        }
    }
    
    code += "}\n"
    return code
}

// MARK: - Kotlin Code Generation
func generateKotlinCode(json: Any, className: String) -> String {
    var code = "import com.google.gson.annotations.SerializedName\n\n"
    code += "data class \(className)(\n"
    
    if let dict = json as? [String: Any] {
        let properties = dict.map { (key, value) in
            let propertyName = toCamelCase(key)
            let type = getKotlinType(value)
            return "    @SerializedName(\"\(key)\")\n    val \(propertyName): \(type)"
        }
        code += properties.joined(separator: ",\n")
    }
    
    code += "\n)"
    return code
}

// MARK: - Java Code Generation
func generateJavaCode(json: Any, className: String) -> String {
    var code = "import com.google.gson.annotations.SerializedName;\n\n"
    code += "public class \(className) {\n"
    
    if let dict = json as? [String: Any] {
        for (key, value) in
        dict {
            let propertyName = toCamelCase(key)
            let type = getJavaType(value)
            code += "    @SerializedName(\"\(key)\")\n"
            code += "    private \(type) \(propertyName);\n\n"
        }
        
        // Getters and Setters
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            let type = getJavaType(value)
            let capitalizedName = propertyName.prefix(1).uppercased() + propertyName.dropFirst()
            
            code += "    public \(type) get\(capitalizedName)() {\n"
            code += "        return \(propertyName);\n"
            code += "    }\n\n"
            
            code += "    public void set\(capitalizedName)(\(type) \(propertyName)) {\n"
            code += "        this.\(propertyName) = \(propertyName);\n"
            code += "    }\n\n"
        }
    }
    
    code += "}"
    return code
}

// MARK: - TypeScript Code Generation
func generateTypeScriptCode(json: Any, className: String) -> String {
    var code = "export interface \(className) {\n"
    
    if let dict = json as? [String: Any] {
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            let type = getTypeScriptType(value)
            code += "    \(propertyName): \(type);\n"
        }
    }
    
    code += "}"
    return code
}

// MARK: - Helper Functions
func toCamelCase(_ text: String) -> String {
    let words = text.components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty }
    guard !words.isEmpty else { return text }
    return words[0].lowercased() + words.dropFirst().map { $0.capitalized }.joined()
}

func getSwiftType(_ value: Any) -> String {
    switch value {
    case is String: return "String"
    case is Int: return "Int"
    case is Double: return "Double"
    case is Bool: return "Bool"
    case is [Any]: return "[Any]"
    case is [String: Any]: return "[String: Any]"
    default: return "Any"
    }
}

func getKotlinType(_ value: Any) -> String {
    switch value {
    case is String: return "String"
    case is Int: return "Int"
    case is Double: return "Double"
    case is Bool: return "Boolean"
    case is [Any]: return "List<Any>"
    case is [String: Any]: return "Map<String, Any>"
    default: return "Any"
    }
}

func getJavaType(_ value: Any) -> String {
    switch value {
    case is String: return "String"
    case is Int: return "Integer"
    case is Double: return "Double"
    case is Bool: return "Boolean"
    case is [Any]: return "List<Object>"
    case is [String: Any]: return "Map<String, Object>"
    default: return "Object"
    }
}

func getTypeScriptType(_ value: Any) -> String {
    switch value {
    case is String: return "string"
    case is Int: return "number"
    case is Double: return "number"
    case is Bool: return "boolean"
    case is [Any]: return "any[]"
    case is [String: Any]: return "Record<string, any>"
    default: return "any"
    }
}

// MARK: - Additional Language Generators (Simplified)
func generateCSharpCode(json: Any, className: String) -> String {
    var code = "using System;\nusing Newtonsoft.Json;\n\n"
    code += "public class \(className)\n{\n"
    
    if let dict = json as? [String: Any] {
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            let type = getCSharpType(value)
            code += "    [JsonProperty(\"\(key)\")]\n"
            code += "    public \(type) \(propertyName) { get; set; }\n\n"
        }
    }
    
    code += "}"
    return code
}

func generateJavaScriptCode(json: Any, className: String) -> String {
    var code = "class \(className) {\n"
    code += "    constructor(data) {\n"
    
    if let dict = json as? [String: Any] {
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            code += "        this.\(propertyName) = data.\(key);\n"
        }
    }
    
    code += "    }\n"
    code += "}\n\n"
    code += "module.exports = \(className);"
    return code
}

func generateDartCode(json: Any, className: String) -> String {
    var code = "class \(className) {\n"
    
    if let dict = json as? [String: Any] {
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            let type = getDartType(value)
            code += "    final \(type) \(propertyName);\n"
        }
        
        code += "\n    \(className)({"
        let params = dict.keys.map { "required this.\(toCamelCase($0))" }.joined(separator: ", ")
        code += params
        code += "});\n"
    }
    
    code += "}"
    return code
}

func generateObjectiveCCode(json: Any, className: String) -> String {
    var code = "#import <Foundation/Foundation.h>\n\n"
    code += "@interface \(className) : NSObject\n"
    
    if let dict = json as? [String: Any] {
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            let type = getObjectiveCType(value)
            code += "@property (nonatomic, strong) \(type) *\(propertyName);\n"
        }
    }
    
    code += "@end"
    return code
}

func generatePHPCode(json: Any, className: String) -> String {
    var code = "<?php\n\n"
    code += "class \(className) {\n"
    
    if let dict = json as? [String: Any] {
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            let type = getPHPType(value)
            code += "    public $\(propertyName);\n"
        }
        
        code += "\n    public function __construct($data) {\n"
        for (key, value) in dict {
            let propertyName = toCamelCase(key)
            code += "        $this->\(propertyName) = $data['\(key)'] ?? null;\n"
        }
        code += "    }\n"
    }
    
    code += "}"
    return code
}

func getCSharpType(_ value: Any) -> String {
    switch value {
    case is String: return "string"
    case is Int: return "int"
    case is Double: return "double"
    case is Bool: return "bool"
    case is [Any]: return "List<object>"
    case is [String: Any]: return "Dictionary<string, object>"
    default: return "object"
    }
}

func getDartType(_ value: Any) -> String {
    switch value {
    case is String: return "String"
    case is Int: return "int"
    case is Double: return "double"
    case is Bool: return "bool"
    case is [Any]: return "List<dynamic>"
    case is [String: Any]: return "Map<String, dynamic>"
    default: return "dynamic"
    }
}

func getObjectiveCType(_ value: Any) -> String {
    switch value {
    case is String: return "NSString"
    case is Int: return "NSNumber"
    case is Double: return "NSNumber"
    case is Bool: return "NSNumber"
    case is [Any]: return "NSArray"
    case is [String: Any]: return "NSDictionary"
    default: return "id"
    }
}

func getPHPType(_ value: Any) -> String {
    switch value {
    case is String: return "string"
    case is Int: return "int"
    case is Double: return "float"
    case is Bool: return "bool"
    case is [Any]: return "array"
    case is [String: Any]: return "array"
    default: return "mixed"
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
