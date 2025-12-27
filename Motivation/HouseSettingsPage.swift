//
//  HouseSettingsPage.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 16/12/2025.
//
import SwiftUI
import Combine
import Foundation

// Shared sections array accessible from any file in the app target.
let sections: [String] = [
    "change of background",
]

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        }
    }
}

struct SettingsList: View {
    // Bind to the same key used in MotivationApp
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    @AppStorage("musicEnabled") private var musicEnabled: Bool = true
    @AppStorage("appLanguage") private var storedLanguage: String = AppLanguage.english.rawValue

    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var notifManager = NotifManager.shared
    @StateObject private var l10n = LocalizationManager.shared

//    Text(l10n.currentLanguage == .english ? "Settings" : "Configuración")

    // Local state for time picker
    @State private var notifTime: Date = {
        var comps = DateComponents()
        comps.hour = UserDefaults.standard.object(forKey: "notifHour") as? Int ?? 9
        comps.minute = UserDefaults.standard.object(forKey: "notifMinute") as? Int ?? 0
        return Calendar.current.date(from: comps) ?? Date()
    }()

    // Alert for destructive reset
    @State private var showResetAlert = false

    private var selectionBinding: Binding<AppColorScheme> {
        Binding(
            get: { AppColorScheme(rawValue: storedScheme) ?? .system },
            set: { storedScheme = $0.rawValue }
        )
    }

    private var languageBinding: Binding<AppLanguage> {
        Binding(
            get: { AppLanguage(rawValue: storedLanguage) ?? .english },
            set: { storedLanguage = $0.rawValue }
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.largeTitle)
                .bold()
                .padding(20)

            List {
                Section("Appearance") {
                    Picker("Appearance", selection: selectionBinding) {
                        ForEach(AppColorScheme.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Music") {
                    Toggle("Background Music", isOn: $audioManager.musicEnabled)
                    if musicEnabled {
                        Slider(value: $audioManager.musicVolume, in: 0...1, step: 0.1)
                            .tint(.blue)
                    }
                }

                Section("Notifications") {
                    Toggle("Enable Daily Notification", isOn: $notifManager.notifEnabled)

                    if notifManager.notifEnabled {
                        DatePicker(
                            "Time",
                            selection: $notifTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.compact)
                        .onChange(of: notifTime) { _, newValue in
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                            let hour = comps.hour ?? 9
                            let minute = comps.minute ?? 0
                            notifManager.setDailyTime(hour: hour, minute: minute)
                        }
                        .onAppear {
                            // Sync local picker with stored time when section appears
                            var comps = DateComponents()
                            comps.hour = notifManager.storedHour
                            comps.minute = notifManager.storedMinute
                            if let date = Calendar.current.date(from: comps) {
                                notifTime = date
                            }
                        }
                    }
                }

                Section("Data") {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Text("Reset everything")
                    }
                    .alert("Reset everything?", isPresented: $showResetAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Reset", role: .destructive) {
                            performFullReset()
                        }
                    } message: {
                        Text("This will clear preferences, notifications, music settings, favorites and notes. This action cannot be undone.")
                    }
                }

                Section("Language") {
                    //                    Picker("Language", selection: languageBinding) {
                    //                        ForEach(AppLanguage.allCases) { option in
                    //                            Text(option.displayName).tag(option)
                    //                        }
                    //                    }
                    //                    .pickerStyle(.segmented)
                    //                }
                    // replace languageBinding usage with:
                    Picker("Language", selection: Binding(
                        get: { AppLanguage(rawValue: storedLanguage) ?? .english },
                        set: { newLang in
                            storedLanguage = newLang.rawValue
                            LocalizationManager.shared.setLanguage(newLang)
                        }
                    ))
                    {
                        ForEach(AppLanguage.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }.pickerStyle(.segmented)
//                    Text(l10n.currentLanguage == .english ? "Settings" : "Configuración")
                }
//                .pickerStyle(.segmented)
//                Text(l10n.currentLanguage == .english ? "Settings" : "Configuración")

                Section("Other") {
                    ForEach(sections, id: \.self) { item in
                        Text(item)
                            .padding(.vertical, 4)
                    }
                }
                
            }
        }
    }

    private func performFullReset() {
        // 1) Stop notifications and disable preference
        NotifManager.shared.stopNotif()
        UserDefaults.standard.set(false, forKey: "notifEnabled")
        // Optionally reset time back to defaults (9:00)
        UserDefaults.standard.set(9, forKey: "notifHour")
        UserDefaults.standard.set(0, forKey: "notifMinute")

        // 2) Reset appearance to system
        UserDefaults.standard.set(AppColorScheme.system.rawValue, forKey: "appColorScheme")
        storedScheme = AppColorScheme.system.rawValue

        // 3) Reset music settings
        UserDefaults.standard.set(false, forKey: "musicEnabled")
        audioManager.setMusicEnabled(false)
        UserDefaults.standard.set(0.5, forKey: "musicVolume")
        audioManager.setMusicVolume(0.5)

        // 4) Clear favorites and notes
        QuoteLibrary.FavoriteStorage.save([])
        QuoteLibrary.NotesStorage.save([])
        NotificationCenter.default.post(name: .didPerformFullReset, object: nil)
    }
}

extension Notification.Name {
    static let didPerformFullReset = Notification.Name("didPerformFullReset")
}

final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    @AppStorage("appLanguage") private var storedLanguage: String = AppLanguage.english.rawValue

    @Published private(set) var currentLanguage: AppLanguage = .english

    private init() {
        currentLanguage = AppLanguage(rawValue: storedLanguage) ?? .english
    }

    func setLanguage(_ lang: AppLanguage) {
        storedLanguage = lang.rawValue
        currentLanguage = lang
        // Post a notification if needed to have other parts react
        NotificationCenter.default.post(name: .didChangeAppLanguage, object: lang)
    }
}

extension Notification.Name {
    static let didChangeAppLanguage = Notification.Name("didChangeAppLanguage")
}

#Preview {
    SettingsList()
}

