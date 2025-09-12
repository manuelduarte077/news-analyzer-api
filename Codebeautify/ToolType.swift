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
    case jwt = "JWT Decoder"
    
    var icon: String {
        switch self {
        case .jsonFormatter: return "curlybraces"
        case .jwt: return "key"
        }
    }
    
    var storageKey: String {
        return "input_\(self.rawValue.replacingOccurrences(of: " ", with: "_"))"
    }
}
