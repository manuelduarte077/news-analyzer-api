//
//  ToolType.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import Foundation

// MARK: - Enums
enum ToolType: String, CaseIterable {
    case jsonFormatter = "JSON Formatter"
    case base64 = "Base64"
    case jwt = "JWT Decoder"
    case hash = "Hash Generator"
    
    var icon: String {
        switch self {
        case .jsonFormatter: return "curlybraces"
        case .base64: return "lock"
        case .jwt: return "key"
        case .hash: return "number"
        }
    }
    
    var storageKey: String {
        return "input_\(self.rawValue.replacingOccurrences(of: " ", with: "_"))"
    }
}
