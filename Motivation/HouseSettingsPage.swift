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
        "Mode - light / dark",
        "Music -- on / off",
        "Notifications -- on / off",
        "Language / Idioma",
        "Delete the account",
        ]
        
        
struct SettingsList: View {
    // Bind to the same key used in MotivationApp
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue

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

                Section("Other") {
                    ForEach(sections, id: \.self) { quote in
                        Text(quote)
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
