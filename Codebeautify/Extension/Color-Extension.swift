//
//  Color.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI

// MARK: - Color Extension for Cross-Platform
extension Color {
    static var customBackground: Color {
        #if os(iOS)
        return Color(.systemBackground)
        #elseif os(macOS)
        return Color(.textBackgroundColor)
        #endif
    }
    
    static var customSecondaryBackground: Color {
        #if os(iOS)
        return Color(.secondarySystemBackground)
        #elseif os(macOS)
        return Color(.windowBackgroundColor)
        #endif
    }
    
    static var customToolbarBackground: Color {
        #if os(iOS)
        return Color(.systemGray6)
        #elseif os(macOS)
        return Color(.controlBackgroundColor)
        #endif
    }
    
    static var customGroupedBackground: Color {
        #if os(iOS)
        return Color(.systemGroupedBackground)
        #elseif os(macOS)
        return Color(.underPageBackgroundColor)
        #endif
    }
}
