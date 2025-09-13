//
//  CodeGenerator.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import Foundation

struct CodeGenerator {
    
    // MARK: - Main Code Generation Logic
    static func generateCodeForLanguage(json: Any, language: ExportLanguage, className: String) -> String {
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
    private static func generateSwiftCode(json: Any, className: String) -> String {
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
    private static func generateKotlinCode(json: Any, className: String) -> String {
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
    private static func generateJavaCode(json: Any, className: String) -> String {
        var code = "import com.google.gson.annotations.SerializedName;\n\n"
        code += "public class \(className) {\n"
        
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
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
    
    // MARK: - C# Code Generation
    private static func generateCSharpCode(json: Any, className: String) -> String {
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
    
    // MARK: - JavaScript Code Generation
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
    
    // MARK: - Dart Code Generation
    private static func generateDartCode(json: Any, className: String) -> String {
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
    
    // MARK: - Objective-C Code Generation
    private static func generateObjectiveCCode(json: Any, className: String) -> String {
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
    
    // MARK: - PHP Code Generation
    private static func generatePHPCode(json: Any, className: String) -> String {
        var code = "<?php\n\n"
        code += "class \(className) {\n"
        
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
                let propertyName = toCamelCase(key)
                _ = getPHPType(value)
                code += "    public $\(propertyName);\n"
            }
            
            code += "\n    public function __construct($data) {\n"
            for (key, _) in dict {
                let propertyName = toCamelCase(key)
                code += "        $this->\(propertyName) = $data['\(key)'] ?? null;\n"
            }
            code += "    }\n"
        }
        
        code += "}"
        return code
    }
    
    // MARK: - Helper Functions
    private static func toCamelCase(_ text: String) -> String {
        let words = text.components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty }
        guard !words.isEmpty else { return text }
        return words[0].lowercased() + words.dropFirst().map { $0.capitalized }.joined()
    }
    
    // MARK: - Type Helpers
    private static func getSwiftType(_ value: Any) -> String {
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
    
    private static func getKotlinType(_ value: Any) -> String {
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
    
    private static func getJavaType(_ value: Any) -> String {
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
    
    private static func getCSharpType(_ value: Any) -> String {
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
    
    private static func getDartType(_ value: Any) -> String {
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
    
    private static func getObjectiveCType(_ value: Any) -> String {
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
    
    private static func getPHPType(_ value: Any) -> String {
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
}
