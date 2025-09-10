//
//  JSONNode.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI

// MARK: - Models
struct JSONNode: Identifiable {
    let id = UUID()
    let key: String?
    let value: Any
    let type: JSONType
    var children: [JSONNode] = []
    var isExpanded: Bool = true
    
    enum JSONType {
        case dictionary
        case array
        case string
        case number
        case boolean
        case null
        
        var displayName: String {
            switch self {
            case .dictionary: return "Object"
            case .array: return "Array"
            case .string: return "String"
            case .number: return "Number"
            case .boolean: return "Boolean"
            case .null: return "Null"
            }
        }
        
        var color: Color {
            switch self {
            case .dictionary: return .blue
            case .array: return .purple
            case .string: return .green
            case .number: return .orange
            case .boolean: return .pink
            case .null: return .gray
            }
        }
    }
}
