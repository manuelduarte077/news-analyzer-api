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
    case urlEncodeDecode = "URL Encode/Decode"
    case base64 = "Base64"
    case jwt = "JWT Decoder"
    case textCase = "Text Case"
    case hash = "Hash Generator"
    
    var icon: String {
        switch self {
        case .jsonFormatter: return "curlybraces"
        case .urlEncodeDecode: return "link"
        case .base64: return "lock"
        case .jwt: return "key"
        case .textCase: return "textformat"
        case .hash: return "number"
        }
    }
    
    var storageKey: String {
        return "input_\(self.rawValue.replacingOccurrences(of: " ", with: "_"))"
    }
}
