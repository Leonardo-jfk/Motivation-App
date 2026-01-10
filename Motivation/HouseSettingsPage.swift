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
    case french = "fr"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English".localized
        case .spanish: return "Español".localized
        case .french: return "French".localized
        }
    }
}
// String extension for localization
extension String {
//    var localized: String {
//        return NSLocalizedString(self, comment: "")
//    }
        var localized: String {
            LocalizationBundle.shared.localizedString(forKey: self)
        }
        
        func localized(with arguments: CVarArg...) -> String {
            String(format: self.localized, arguments: arguments)
        }
    }
//    func localized(with arguments: CVarArg...) -> String {
//        return String(format: self.localized, arguments: arguments)
//    }
//}
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
            Text("settings_title".localized)
                .font(.largeTitle)
                .bold()
                .padding(20)
            
            List {
                Section("appearance_title".localized) {
                    Picker("appearance_picker".localized, selection: selectionBinding) {
                        ForEach(AppColorScheme.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("music_title".localized) {
                    Toggle("music_toggle".localized, isOn: $audioManager.musicEnabled)
                    if musicEnabled {
                        Slider(value: $audioManager.musicVolume, in: 0...1, step: 0.1)
                            .tint(.blue)
                    }
                }
                
                Section("notifications_title".localized) {
                    Toggle("notifications_toggle".localized, isOn: $notifManager.notifEnabled)
                    
                    if notifManager.notifEnabled {
                        DatePicker(
                            "notifications_time".localized,
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
                
                Section("data_title".localized) {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Text("data_reset_button".localized)
                    }
                    .alert("data_reset_alert_title".localized, isPresented: $showResetAlert) {
                        Button("cancel".localized, role: .cancel) {}
                        Button("reset".localized, role: .destructive) {
                            performFullReset()
                        }
                    } message: {
                        Text("data_reset_alert_message".localized)
                    }
                }
                
                Section("language_section".localized) {
                    Picker("language_picker".localized, selection: Binding(
                        get: { AppLanguage(rawValue: storedLanguage) ?? .english },
                        set: { newLang in
                            storedLanguage = newLang.rawValue
                            l10n.setLanguage(newLang)
                        }
                    )) {
                        ForEach(AppLanguage.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("other_title".localized) {
                    ForEach(sections, id: \.self) { item in
                        Text(item)
                            .padding(.vertical, 4)
                    }
                }
                
            }
        }.id(l10n.currentLanguage)
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
        FavoriteStorage.save([])
        NotesStorage.save([])
        NotificationCenter.default.post(name: .didPerformFullReset, object: nil)
        
//        TrackView.lastDatePracticed.save([])
//        TrackView.daysPracticed.set(0)
        UserDefaults.standard.set(0, forKey: "daysPracticed")
        UserDefaults.standard.set("", forKey: "lastDatePracticed")
    }
}

extension Notification.Name {
    static let didPerformFullReset = Notification.Name("didPerformFullReset")
}

final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    @AppStorage("appLanguage") private var storedLanguage: String = AppLanguage.english.rawValue

    @Published private(set) var currentLanguage: AppLanguage = .english

//    private init() {
//        currentLanguage = AppLanguage(rawValue: storedLanguage) ?? .english
//    }
    private init() {
        let lang = AppLanguage(rawValue: storedLanguage) ?? .english
        LocalizationBundle.shared.update(for: lang)
        currentLanguage = lang
    }
//
//    func setLanguage(_ lang: AppLanguage) {
//        storedLanguage = lang.rawValue
//        currentLanguage = lang
//        objectWillChange.send()
//        // Post a notification if needed to have other parts react
//        NotificationCenter.default.post(name: .didChangeAppLanguage, object: lang)
//    }
    func setLanguage(_ lang: AppLanguage) {
        storedLanguage = lang.rawValue
        LocalizationBundle.shared.update(for: lang)
        currentLanguage = lang
        objectWillChange.send()
        NotificationCenter.default.post(name: .didChangeAppLanguage, object: lang)
    }
    
}
final class LocalizationBundle {
    static let shared = LocalizationBundle()
    private init() {}

    private var bundle: Bundle = .main

    func update(for language: AppLanguage) {
        // Find the .lproj path for selected language
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            bundle = langBundle
        } else {
            bundle = .main
        }
    }

    func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}

extension Notification.Name {
    static let didChangeAppLanguage = Notification.Name("didChangeAppLanguage")
}

#Preview {
    SettingsList()
}

