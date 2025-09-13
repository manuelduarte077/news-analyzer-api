//
//  Color.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI

// MARK: - Color Extension for macOS
extension Color {
    static var customBackground: Color {
        return Color(.textBackgroundColor)
    }
    
    static var customSecondaryBackground: Color {
        return Color(.windowBackgroundColor)
    }
    
    static var customToolbarBackground: Color {
        return Color(.controlBackgroundColor)
    }
    
    static var customGroupedBackground: Color {
        return Color(.underPageBackgroundColor)
    }
}
