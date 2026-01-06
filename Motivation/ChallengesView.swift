//
//  ChallengesView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 05/01/2026.
//

import Foundation
import SwiftUI
import Lottie


public struct ChallengesView: View {
    
    
    var fileName: String = "Girl with books"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .loop
    var onAnimationDidFinish: (() -> Void)? = nil
    
    public var body: some View {
        
        ZStack{
            LottieView(animation: .named("SciFiBack"))
                .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
                 lottieAnimationView.animationSpeed = 0.2
                })
                
                .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
                .animationDidFinish { completed in onAnimationDidFinish?()
                        
                }
                .resizable()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Rectangle()
                .frame(width:100, height: 200)
                .foregroundStyle(.white)
         
            VStack {
                Text("Challenges List")
                    .font(.largeTitle)
                Image(systemName: "book").resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                // Your future challenges logic here
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ChallengesView()
}
