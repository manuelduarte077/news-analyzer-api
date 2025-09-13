//
//  SyntaxHighlighter.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI
import Foundation

struct SyntaxHighlighter: View {
    let code: String
    let language: ExportLanguage
    @State private var highlightedCode: AttributedString = AttributedString()
    
    var body: some View {
        ScrollView {
            Text(highlightedCode)
                .font(.system(.caption, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(12)
        }
        .onAppear {
            highlightedCode = highlightCode(code, for: language)
        }
        .onChange(of: code) { _, newCode in
            highlightedCode = highlightCode(newCode, for: language)
        }
        .onChange(of: language) { _, newLanguage in
            highlightedCode = highlightCode(code, for: newLanguage)
        }
    }
    
    private func highlightCode(_ code: String, for language: ExportLanguage) -> AttributedString {
        let attributedString = AttributedString(code)
        
        switch language {
        case .swift:
            return highlightSwift(attributedString)
        case .kotlin:
            return highlightKotlin(attributedString)
        case .java:
            return highlightJava(attributedString)
        case .csharp:
            return highlightCSharp(attributedString)
        case .typescript:
            return highlightTypeScript(attributedString)
        case .javascript:
            return highlightJavaScript(attributedString)
        case .dart:
            return highlightDart(attributedString)
        case .objectivec:
            return highlightObjectiveC(attributedString)
        case .php:
            return highlightPHP(attributedString)
        }
    }
    
    // MARK: - Swift Highlighting
    private func highlightSwift(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        
        // Keywords
        let keywords = ["import", "struct", "class", "enum", "protocol", "extension", "func", "var", "let", "if", "else", "for", "while", "switch", "case", "default", "return", "public", "private", "internal", "static", "final", "override", "init", "deinit", "self", "super", "nil", "true", "false", "as", "is", "in", "where", "guard", "defer", "do", "catch", "try", "throw", "throws", "rethrows", "async", "await", "throws", "Codable", "Identifiable", "Hashable", "Equatable", "Comparable"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        // Types
        let types = ["String", "Int", "Double", "Float", "Bool", "Array", "Dictionary", "Set", "Optional", "Any", "AnyObject", "NSObject", "UIView", "UIViewController", "Data", "URL", "Date", "UUID"]
        
        for type in types {
            result = highlightPattern("\\b\(type)\\b", in: result, color: .blue, weight: .medium)
        }
        
        // Strings
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        
        // Comments
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        
        // Numbers
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    // MARK: - Kotlin Highlighting
    private func highlightKotlin(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        
        let keywords = ["import", "class", "data class", "object", "interface", "enum class", "fun", "val", "var", "if", "else", "when", "for", "while", "do", "try", "catch", "finally", "throw", "return", "this", "super", "null", "true", "false", "as", "is", "in", "out", "override", "open", "final", "abstract", "sealed", "internal", "private", "protected", "public", "const", "lateinit", "companion", "init", "constructor", "by", "delegate", "infix", "operator", "inline", "noinline", "crossinline", "reified", "suspend", "async", "await"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        let types = ["String", "Int", "Long", "Double", "Float", "Boolean", "Char", "Byte", "Short", "Array", "List", "Set", "Map", "MutableList", "MutableSet", "MutableMap", "Any", "Nothing", "Unit", "Pair", "Triple"]
        
        for type in types {
            result = highlightPattern("\\b\(type)\\b", in: result, color: .blue, weight: .medium)
        }
        
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    // MARK: - Java Highlighting
    private func highlightJava(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        
        let keywords = ["import", "package", "public", "private", "protected", "static", "final", "abstract", "class", "interface", "enum", "extends", "implements", "new", "this", "super", "if", "else", "switch", "case", "default", "for", "while", "do", "break", "continue", "return", "try", "catch", "finally", "throw", "throws", "synchronized", "volatile", "transient", "native", "strictfp", "assert", "const", "goto", "true", "false", "null"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        let types = ["String", "int", "long", "double", "float", "boolean", "char", "byte", "short", "void", "Object", "Integer", "Long", "Double", "Float", "Boolean", "Character", "Byte", "Short", "List", "ArrayList", "Map", "HashMap", "Set", "HashSet"]
        
        for type in types {
            result = highlightPattern("\\b\(type)\\b", in: result, color: .blue, weight: .medium)
        }
        
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    // MARK: - TypeScript Highlighting
    private func highlightTypeScript(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        
        let keywords = ["export", "import", "interface", "type", "class", "function", "const", "let", "var", "if", "else", "switch", "case", "default", "for", "while", "do", "break", "continue", "return", "try", "catch", "finally", "throw", "async", "await", "public", "private", "protected", "static", "readonly", "abstract", "extends", "implements", "this", "super", "null", "undefined", "true", "false", "as", "is", "in", "of", "typeof", "instanceof", "new", "delete", "void"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        let types = ["string", "number", "boolean", "object", "array", "any", "unknown", "never", "void", "null", "undefined", "Record", "Partial", "Required", "Pick", "Omit", "Exclude", "Extract", "NonNullable", "ReturnType", "Parameters", "ConstructorParameters", "ThisParameterType", "OmitThisParameter", "ThisType"]
        
        for type in types {
            result = highlightPattern("\\b\(type)\\b", in: result, color: .blue, weight: .medium)
        }
        
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        result = highlightPattern("'[^']*'", in: result, color: .green, weight: .regular)
        result = highlightPattern("`[^`]*`", in: result, color: .green, weight: .regular)
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    // MARK: - Other Languages (Simplified)
    private func highlightCSharp(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        let keywords = ["using", "namespace", "class", "interface", "struct", "enum", "public", "private", "protected", "internal", "static", "readonly", "const", "var", "if", "else", "switch", "case", "default", "for", "while", "do", "foreach", "break", "continue", "return", "try", "catch", "finally", "throw", "new", "this", "base", "null", "true", "false", "as", "is", "in", "out", "ref", "params", "override", "virtual", "abstract", "sealed", "partial", "async", "await", "get", "set", "add", "remove"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    private func highlightJavaScript(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        let keywords = ["function", "const", "let", "var", "if", "else", "switch", "case", "default", "for", "while", "do", "break", "continue", "return", "try", "catch", "finally", "throw", "async", "await", "class", "extends", "import", "export", "from", "this", "super", "new", "delete", "typeof", "instanceof", "in", "of", "null", "undefined", "true", "false"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        result = highlightPattern("'[^']*'", in: result, color: .green, weight: .regular)
        result = highlightPattern("`[^`]*`", in: result, color: .green, weight: .regular)
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    private func highlightDart(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        let keywords = ["import", "library", "class", "abstract", "interface", "mixin", "enum", "typedef", "extension", "part", "part of", "export", "show", "hide", "as", "if", "else", "for", "while", "do", "switch", "case", "default", "break", "continue", "return", "try", "catch", "finally", "throw", "rethrow", "assert", "const", "final", "static", "late", "required", "external", "factory", "get", "set", "operator", "this", "super", "new", "null", "true", "false", "async", "await", "sync", "yield", "yield*"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        result = highlightPattern("'[^']*'", in: result, color: .green, weight: .regular)
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    private func highlightObjectiveC(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        let keywords = ["#import", "#include", "@interface", "@implementation", "@end", "@property", "@synthesize", "@dynamic", "@selector", "@protocol", "@optional", "@required", "@class", "@public", "@private", "@protected", "@package", "@try", "@catch", "@finally", "@throw", "@synchronized", "@autoreleasepool", "@available", "@objc", "@objcMembers", "@objcMethod", "@objcProperty", "@objcProtocol", "@objcRuntime", "@objcType", "if", "else", "switch", "case", "default", "for", "while", "do", "break", "continue", "return", "goto", "sizeof", "typedef", "extern", "static", "const", "volatile", "register", "auto", "struct", "union", "enum", "id", "SEL", "IMP", "BOOL", "YES", "NO", "nil", "Nil", "NULL"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    private func highlightPHP(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        let keywords = ["<?php", "?>", "class", "interface", "trait", "namespace", "use", "as", "public", "private", "protected", "static", "final", "abstract", "const", "function", "if", "else", "elseif", "switch", "case", "default", "for", "foreach", "while", "do", "break", "continue", "return", "try", "catch", "finally", "throw", "new", "clone", "instanceof", "this", "self", "parent", "null", "true", "false", "and", "or", "xor", "not", "isset", "empty", "unset", "echo", "print", "die", "exit", "include", "require", "include_once", "require_once", "global", "static", "var", "array", "string", "int", "float", "bool", "object", "resource", "mixed", "callable", "iterable", "void", "never"]
        
        for keyword in keywords {
            result = highlightPattern("\\b\(keyword)\\b", in: result, color: .purple, weight: .semibold)
        }
        
        result = highlightPattern("\"[^\"]*\"", in: result, color: .green, weight: .regular)
        result = highlightPattern("'[^']*'", in: result, color: .green, weight: .regular)
        result = highlightPattern("//.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("/\\*[\\s\\S]*?\\*/", in: result, color: .gray, weight: .regular)
        result = highlightPattern("#.*$", in: result, color: .gray, weight: .regular)
        result = highlightPattern("\\b\\d+\\.?\\d*\\b", in: result, color: .orange, weight: .regular)
        
        return result
    }
    
    // MARK: - Helper Function
    private func highlightPattern(_ pattern: String, in attributedString: AttributedString, color: Color, weight: Font.Weight) -> AttributedString {
        var result = attributedString
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines])
            let range = NSRange(location: 0, length: result.characters.count)
            
            let matches = regex.matches(in: String(result.characters), options: [], range: range)
            
            for match in matches.reversed() {
                let startIndex = result.index(result.startIndex, offsetByCharacters: match.range.location)
                let endIndex = result.index(startIndex, offsetByCharacters: match.range.length)
                
                result[startIndex..<endIndex].foregroundColor = color
                result[startIndex..<endIndex].font = .system(.caption, design: .monospaced).weight(weight)
            }
        } catch {
            // If regex fails, return original string
            return attributedString
        }
        
        return result
    }
}
