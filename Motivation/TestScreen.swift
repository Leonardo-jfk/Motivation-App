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
    var fileName: String = "Girl with books"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .autoReverse
    
    var onAnimationDidFinish: (() -> Void)? = nil
    
    var body: some View {
        AnimationView()
        Text("books should be here")
        LottieView(animation: .named(fileName))
            .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
            })
            .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
            .animationDidFinish { completed in onAnimationDidFinish?()
            }
            .frame(width: 100, height: 100)
    }
}
#Preview {
    TestScreenView()
}

