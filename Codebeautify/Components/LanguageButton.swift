//
//  LanguageButton.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI

// MARK: - Language Button Component
struct LanguageButton: View {
    let language: ExportLanguage
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: language.icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                
                Text(language.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(backgroundShape)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Computed Properties
    private var iconColor: Color {
        isSelected ? .white : .blue
    }
    
    private var textColor: Color {
        isSelected ? .white : .primary
    }
    
    private var backgroundShape: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(backgroundColor)
            .overlay(borderOverlay)
    }
    
    private var backgroundColor: Color {
        isSelected ? Color.blue : Color.gray.opacity(0.1)
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(borderColor, lineWidth: 1)
    }
    
    private var borderColor: Color {
        isSelected ? Color.blue : Color.clear
    }
}
