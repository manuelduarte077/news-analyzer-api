//
//  CodeGenerator.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import Foundation

struct CodeGenerator {
    
    // MARK: - Main Generation Function
    static func generateCodeForLanguage(json: Any, language: ExportLanguage, className: String) -> String {
        // Validate inputs
        guard !className.isEmpty else {
            return "// Error: Class name cannot be empty"
        }
        
        // Use a more efficient approach for large JSON objects
        return generateCodeForLanguageOptimized(json: json, language: language, className: className)
    }
    
    // MARK: - Async Generation (for large JSON objects)
    static func generateCodeForLanguageAsync(json: Any, language: ExportLanguage, className: String) async -> String {
        return await withTaskGroup(of: String.self) { group in
            group.addTask {
                return generateCodeForLanguage(json: json, language: language, className: className)
            }
            
            // Wait for the first (and only) task to complete
            for await result in group {
                return result
            }
            
            return "// Error: Failed to generate code"
        }
    }
    
    // MARK: - Optimized Generation
    private static func generateCodeForLanguageOptimized(json: Any, language: ExportLanguage, className: String) -> String {
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
        case .objectivec:
            return generateObjectiveCCode(json: json, className: className)
        }
    }
    
    
    private static func generateSwiftCode(json: Any, className: String) -> String {
        var code = "import Foundation\n\n"
        code += "struct \(className): Codable {\n"
        
        if let dict = json as? [String: Any] {
            // Use more efficient string building
            let properties = dict.compactMap { (key, value) -> String? in
                let propertyName = toCamelCase(key)
                let type = getSwiftType(value, key: key)
                return "    let \(propertyName): \(type)"
            }
            code += properties.joined(separator: "\n")
            if !properties.isEmpty {
                code += "\n"
            }
        }
        
        code += "}\n"
        return code
    }
    
    
    private static func generateKotlinCode(json: Any, className: String) -> String {
        var code = "import com.google.gson.annotations.SerializedName\n\n"
        code += "data class \(className)(\n"
        
        if let dict = json as? [String: Any] {
            let properties = dict.map { (key, value) in
                let propertyName = toCamelCase(key)
                let type = getKotlinType(value, key: key)
                return "    @SerializedName(\"\(key)\")\n    val \(propertyName): \(type)"
            }
            code += properties.joined(separator: ",\n")
        }
        
        code += "\n)"
        return code
    }
    
    
    private static func generateJavaCode(json: Any, className: String) -> String {
        var code = "import com.google.gson.annotations.SerializedName;\n\n"
        code += "public class \(className) {\n"
        
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
                let propertyName = toCamelCase(key)
                let type = getJavaType(value, key: key)
                code += "    @SerializedName(\"\(key)\")\n"
                code += "    private \(type) \(propertyName);\n\n"
            }
            
            
            for (key, value) in dict {
                let propertyName = toCamelCase(key)
                let type = getJavaType(value, key: key)
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
    
    
    private static func generateTypeScriptCode(json: Any, className: String) -> String {
        var code = "export interface \(className) {\n"
        
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
                let propertyName = toCamelCase(key)
                let type = getTypeScriptType(value, key: key)
                code += "    \(propertyName): \(type);\n"
            }
        }
        
        code += "}"
        return code
    }
    
    
    private static func generateCSharpCode(json: Any, className: String) -> String {
        var code = "using System;\nusing Newtonsoft.Json;\n\n"
        code += "public class \(className)\n{\n"
        
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
                let propertyName = toCamelCase(key)
                let type = getCSharpType(value, key: key)
                code += "    [JsonProperty(\"\(key)\")]\n"
                code += "    public \(type) \(propertyName) { get; set; }\n\n"
            }
        }
        
        code += "}"
        return code
    }
    
    
    private static func generateJavaScriptCode(json: Any, className: String) -> String {
        var code = "/**\n"
        code += " * @typedef {Object} \(className)\n"
        
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
                let propertyName = toCamelCase(key)
                let type = getJSDocType(value, key: key)
                code += " * @property {\(type)} \(propertyName) - \(key)\n"
            }
        }
        
        code += " */\n\n"
        code += "class \(className) {\n"
        code += "    /**\n"
        code += "     * @param {Object} data - The data object\n"
        code += "     */\n"
        code += "    constructor(data) {\n"
        
        if let dict = json as? [String: Any] {
            for (key, _) in dict {
                let propertyName = toCamelCase(key)
                code += "        this.\(propertyName) = data.\(key);\n"
            }
        }
        
        code += "    }\n"
        code += "}\n\n"
        code += "module.exports = \(className);"
        return code
    }
    
    
    
    private static func generateObjectiveCCode(json: Any, className: String) -> String {
        var code = "#import <Foundation/Foundation.h>\n\n"
        code += "@interface \(className) : NSObject\n"
        
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
                let propertyName = toCamelCase(key)
                let type = getObjectiveCType(value, key: key)
                code += "@property (nonatomic, strong) \(type)\(propertyName);\n"
            }
        }
        
        code += "@end"
        return code
    }
    
    
    
    private static func toCamelCase(_ text: String) -> String {
        // Optimize for common cases
        guard !text.isEmpty else { return text }
        
        // Check if already in camelCase
        if text.first?.isLowercase == true && !text.contains("_") && !text.contains("-") {
            return text
        }
        
        let words = text.components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty }
        guard !words.isEmpty else { return text }
        
        // More efficient string building
        var result = words[0].lowercased()
        for word in words.dropFirst() {
            result += word.capitalized
        }
        return result
    }
    
    
    private static func getSwiftType(_ value: Any, key: String) -> String {
        switch value {
        case is String: return "String"
        case is Int: return "Int"
        case is Double: return "Double"
        case is Bool: return "Bool"
        case is [Any]:
            if let array = value as? [Any], !array.isEmpty {
                let elementType = getSwiftType(array.first!, key: key)
                return "[\(elementType)]"
            }
            return "[String]" 
        case is [String: Any]:
            // Optimize class name generation
            let className = key.capitalized + "Data"
            return className
        case is NSNull: return "String?" 
        default: return "String" 
        }
    }
    
    private static func getKotlinType(_ value: Any, key: String) -> String {
        switch value {
        case is String: return "String"
        case is Int: return "Int"
        case is Double: return "Double"
        case is Bool: return "Boolean"
        case is [Any]:
            if let array = value as? [Any], !array.isEmpty {
                let elementType = getKotlinType(array.first!, key: key)
                return "List<\(elementType)>"
            }
            return "List<String>" 
        case is [String: Any]:
            let className = key.capitalized + "Data"
            return className
        case is NSNull: return "String?" 
        default: return "String" 
        }
    }
    
    private static func getJavaType(_ value: Any, key: String) -> String {
        switch value {
        case is String: return "String"
        case is Int: return "Integer"
        case is Double: return "Double"
        case is Bool: return "Boolean"
        case is [Any]:
            if let array = value as? [Any], !array.isEmpty {
                let elementType = getJavaType(array.first!, key: key)
                return "List<\(elementType)>"
            }
            return "List<String>" 
        case is [String: Any]:
            let className = key.capitalized + "Data"
            return className
        case is NSNull: return "String" 
        default: return "String" 
        }
    }
    
    private static func getTypeScriptType(_ value: Any, key: String) -> String {
        switch value {
        case is String: return "string"
        case is Int: return "number"
        case is Double: return "number"
        case is Bool: return "boolean"
        case is [Any]:
            if let array = value as? [Any], !array.isEmpty {
                let elementType = getTypeScriptType(array.first!, key: key)
                return "\(elementType)[]"
            }
            return "unknown[]"
        case is [String: Any]:
            if let dict = value as? [String: Any] {
                var properties: [String] = []
                for (propKey, propValue) in dict {
                    let propType = getTypeScriptType(propValue, key: propKey)
                    properties.append("\(propKey): \(propType)")
                }
                if properties.isEmpty {
                    return "Record<string, unknown>"
                }
                return "{ \(properties.joined(separator: "; ")) }"
            }
            return "Record<string, unknown>"
        case is NSNull: return "null"
        default: return "unknown"
        }
    }
    
    private static func getJSDocType(_ value: Any, key: String) -> String {
        switch value {
        case is String: return "string"
        case is Int: return "number"
        case is Double: return "number"
        case is Bool: return "boolean"
        case is [Any]:
            if let array = value as? [Any], !array.isEmpty {
                let elementType = getJSDocType(array.first!, key: key)
                return "\(elementType)[]"
            }
            return "Array"
        case is [String: Any]:
            if let dict = value as? [String: Any] {
                var properties: [String] = []
                for (propKey, propValue) in dict {
                    let propType = getJSDocType(propValue, key: propKey)
                    properties.append("\(propKey): \(propType)")
                }
                if properties.isEmpty {
                    return "Object"
                }
                return "{\(properties.joined(separator: ", "))}"
            }
            return "Object"
        case is NSNull: return "null"
        default: return "*"
        }
    }
    
    private static func getCSharpType(_ value: Any, key: String) -> String {
        switch value {
        case is String: return "string"
        case is Int: return "int"
        case is Double: return "double"
        case is Bool: return "bool"
        case is [Any]:
            if let array = value as? [Any], !array.isEmpty {
                let elementType = getCSharpType(array.first!, key: key)
                return "List<\(elementType)>"
            }
            return "List<string>" 
        case is [String: Any]:
            let className = key.capitalized + "Data"
            return className
        case is NSNull: return "string?" 
        default: return "string" 
        }
    }
    
    
    private static func getObjectiveCType(_ value: Any, key: String) -> String {
        switch value {
        case is String: return "NSString *"
        case is Int: return "NSNumber *"
        case is Double: return "NSNumber *"
        case is Bool: return "NSNumber *"
        case is [Any]:
            if let array = value as? [Any], !array.isEmpty {
                let elementType = getObjectiveCType(array.first!, key: key)
                return "NSArray<\(elementType)> *"
            }
            return "NSArray<NSString *> *" 
        case is [String: Any]:
            let className = key.capitalized + "Data"
            return "\(className) *"
        case is NSNull: return "NSString *" 
        default: return "NSString *" 
        }
    }
    
}
