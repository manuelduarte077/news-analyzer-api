//
//  ExportLanguage.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import Foundation

enum ExportLanguage: String, CaseIterable {
    case java = "Java"
    case kotlin = "Kotlin"
    case csharp = "C#"
    case swift = "Swift"
    case objectivec = "Objective-C"
    case typescript = "TypeScript"
    case javascript = "JavaScript"
    
    var fileExtension: String {
        switch self {
        case .java: return "java"
        case .kotlin: return "kt"
        case .csharp: return "cs"
        case .swift: return "swift"
        case .objectivec: return "h"
        case .typescript: return "ts"
        case .javascript: return "js"
        }
    }
    
    var icon: String {
        switch self {
        case .java: return "cup.and.saucer"
        case .kotlin: return "k.circle"
        case .csharp: return "c.circle"
        case .swift: return "swift"
        case .objectivec: return "o.circle"
        case .typescript: return "t.circle"
        case .javascript: return "j.circle"
        }
    }
}
