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
    var fileName: String = "Girl with books.json"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .playOnce
    var onAnimationDidFinish: (() -> Void)? = nil
    
//    var body: some View {
//        AnimationView()
//        Text("books should be here")
//        LottieView(animation: .named("fileName"))
//            .playbackMode(.toProgress(1, loopMode: .autoReverse))
//            .frame(width: 100, height: 100)
//    }
    
    var body: some View {
        Text("books should be here")
        LottieView(animation: .named(fileName))
            .configure { animationView in
                animationView.contentMode = contentMode
            }
            .playbackMode(.playing(range: 0.0...1.0, loopMode: playLoopMode))
            .animationDidFinish{complited in
                onAnimationDidFinish?()
                
            }
    }
}


#Preview {
    TestScreenView()
}

