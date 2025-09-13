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
    
    var icon: String {
        switch self {
        case .jsonFormatter: return "curlybraces"
        }
    }
    
    var storageKey: String {
        return "input_\(self.rawValue.replacingOccurrences(of: " ", with: "_"))"
    }
}
