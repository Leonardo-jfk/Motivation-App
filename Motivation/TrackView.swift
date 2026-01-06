//
//  TrackView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 06/01/2026.
//

import Foundation
import SwiftUI
import Lottie


public struct TrackView: View {
    
    var fileName: String = "Girl with books"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .playOnce
    var onAnimationDidFinish: (() -> Void)? = nil
    
    
    public var body: some View {
        ZStack{
            LottieView(animation: .named("LightBackground"))
                .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
                })
                .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
                .animationDidFinish { completed in onAnimationDidFinish?()
                }
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Text("Challenges List")
                    .font(.largeTitle)
                Image(systemName: "heart").resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                // Your future challenges logic here
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


#Preview {
    TrackView()
}
