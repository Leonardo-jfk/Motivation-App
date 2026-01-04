//
//  TestScreen.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 02/01/2026.
//

import Foundation
import SwiftUI
import Lottie

struct TestScreenView: View {
    
    var body: some View {
        AnimationView()
        Text("books should be here")
        LottieView(animation: .named("Girl with books.json"))
            .playbackMode(.toProgress(1, loopMode: .autoReverse))
            .frame(width: 100, height: 100)
    }
}

#Preview {
    TestScreenView()
}
