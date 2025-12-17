//
//  MotivationApp.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 04/10/2025.
//

import SwiftUI

// Persisted app-wide color scheme preference
enum AppColorScheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var preferredColorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

@main
struct MotivationApp: App {
    // Read the user’s choice from persistent storage
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue

    private var appScheme: AppColorScheme {
        AppColorScheme(rawValue: storedScheme) ?? .system
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appScheme.preferredColorScheme)
        }
    }
}
