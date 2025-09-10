//
//  JSONTreeNodeView.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI

// MARK: - Tree View Component
struct JSONTreeNodeView: View {
    let node: JSONNode
    let level: Int
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                ForEach(0..<level, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 20)
                }
                
                if !node.children.isEmpty {
                    Button(action: {
                            isExpanded.toggle()
//
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .rotationEffect(.degrees(isExpanded ? 0 : -90))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 16)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 16)
                }
                
                // Key
                if let key = node.key {
                    Text(key)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.primary)
                    Text(":")
                        .foregroundColor(.secondary)
                }
                
                // Type
                Text(node.type.displayName)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(node.type.color.opacity(0.2))
                    .foregroundColor(node.type.color)
                    .cornerRadius(4)
                
                // Value (for primitives)
                if node.children.isEmpty {
                    Text(String(describing: node.value))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // Count (for collections)
                if !node.children.isEmpty {
                    Text("(\(node.children.count) items)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 2)
            
            // Children
            if isExpanded && !node.children.isEmpty {
                ForEach(node.children) { child in
                    JSONTreeNodeView(node: child, level: level + 1)
                }
            }
        }
    }
}
