//
//  MotivationApp.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 04/10/2025.
//

import SwiftUI
import UserNotifications
import Foundation

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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var l10n = LocalizationManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appScheme.preferredColorScheme)
                .onAppear {
                    NotifManager.shared.requestPermission()
                    
                    NotifManager.shared.sheduleDailyNotification(
                        hour:9,
                        minute: 0,
                        title: "Your wisdom",
                        body: "Marco Aurelio"
                    )
                }
                .id(l10n.currentLanguage) // Force entire app to reload on language change
                .environmentObject(l10n)
        }
        .windowResizability(.contentSize)
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        NotifManager.shared.requestPermission()
        return true
    }
}

