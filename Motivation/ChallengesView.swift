//
//  ChallengesView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 05/01/2026.
//

import Foundation
import SwiftUI
import Lottie


struct ChallengesView: View {
    var body: some View {
        VStack {
            Text("Challenges List")
                .font(.largeTitle)
            Image(systemName: "book").resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            // Your future challenges logic here
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    ChallengesView()
}
