//
//  HouseSettingsPage.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 16/12/2025.
//
import SwiftUI

// Shared quotes array accessible from any file in the app target.
// You can add more quotes here; keep them as comma-separated Swift string literals.
let sections: [String] = [
    
        // Enero (1-31)
      
        "Notifications -- on / off",
        "Language / Idioma",
        "Delete the account",
]

struct SettingsList: View {
    // Bind to the same key used in MotivationApp
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    @AppStorage("musicEnabled") private var musicEnabled: Bool = true
    
    //    @AudioManager.shared.setMusicEnabled(true)
    @StateObject private var audioManager = AudioManager.shared
    
    
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
                    Toggle("Volume", isOn:  $audioManager.musicEnabled)
                        .onChange(of: audioManager.musicEnabled)
                    { oldValue, newValue in
                        // oldValue: previous value
                        // newValue: current value
                        AudioManager.shared.setMusicEnabled(newValue)
                    }
                    if musicEnabled == true{
                        Slider(value: $audioManager.musicVolume, in: 0...1, step: 0.1)
                            .tint(.blue)
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

#Preview {
    SettingsList()
}
