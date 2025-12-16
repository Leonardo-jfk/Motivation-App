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
        
        
struct SettingList: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.largeTitle)
                .bold()
                .padding(20)

            List {
                ForEach(sections, id: \.self) { quote in
                    Text(quote)
                        .padding(.vertical, 4)
                }
            }
        
        }
    }
}

#Preview {
    SettingList()
}
