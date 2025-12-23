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
            
        Section("Notification") {
            Toggle("Choose the time", isOn:  $notifManager.notifEnabled)
                .onChange(of: notifManager.notifEnabled)
            { oldValue, newValue in
                // oldValue: previous value
                // newValue: current value
                NotifManager.shared.setNotifEnabled(newValue)
                
            }
            if musicEnabled == true{
                HStack {
                    TextField("Choose the time", text: $notetext, axis: .vertical)
                        .textfieldstyle(.plain)
                        .lineLimit(1)
                    Button("Add") {
                        let trimmed = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        savedUserTime.insert(trimmed)
                        NotesStorage.save(savedUserTime) // persist immediately
                        noteText = ""
                    }
                    .buttonStyle(.glassProminent)
                }
                .padding(.horizontal)
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
