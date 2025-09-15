//
//  CodebeautifyApp.swift
//  Codebeautify
//
//  Created by Manuel Duarte on 10/9/25.
//

import SwiftUI
import FirebaseCore

@main
struct CodebeautifyApp: App {
    
    init() {
        // Firebase will be configured by FirebaseManager when needed
        // This prevents duplicate configuration errors
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
