//
//  AutoQAApp.swift
//  AutoQA
//
//  Created by Sayed on 27/03/26.
//

import SwiftUI

@main
struct AutoQAApp: App {
    @StateObject var themeManager = ThemeManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager) // 👈 inject
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
