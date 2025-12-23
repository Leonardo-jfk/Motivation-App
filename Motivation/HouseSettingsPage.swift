//
//  HouseSettingsPage.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 16/12/2025.
//
import SwiftUI
import Combine
import Foundation

// Shared quotes array accessible from any file in the app target.
// You can add more quotes here; keep them as comma-separated Swift string literals.
let sections: [String] = [
      
        "Notifications -- on / off",
        "Language / Idioma",
        "Delete the account",
]

struct SettingsList: View {
    // Bind to the same key used in MotivationApp
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    @AppStorage("musicEnabled") private var musicEnabled: Bool = true
    
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var notifManager = NotifManager.shared
    
    // Local state for time picker
    @State private var notifTime: Date = {
        var comps = DateComponents()
        comps.hour = UserDefaults.standard.object(forKey: "notifHour") as? Int ?? 9
        comps.minute = UserDefaults.standard.object(forKey: "notifMinute") as? Int ?? 0
        return Calendar.current.date(from: comps) ?? Date()
    }()
    
    private var selectionBinding: Binding<AppColorScheme> {
        Binding(
            get: { AppColorScheme(rawValue: storedScheme) ?? .system },
            set: { storedScheme = $0.rawValue }
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
                
                Section("Other") {
                    ForEach(sections, id: \.self) { item in
                        Text(item)
                            .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsList()
}
