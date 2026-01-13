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
            NavigationStack{
                
                
                VStack {
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width:150, height: 100)
                                .foregroundStyle(.gray)
                            NavigationLink("1st", destination:
                                Challenge1View())
                            }
                        }
                        Rectangle()
                            .frame(width:150, height: 100)
                            .foregroundStyle(.gray)
                        
                        
                    }
                    Text("Challenges List")
                        .font(.largeTitle)
                    Image(systemName: "book").resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    // Your future challenges logic here
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            }.frame(maxWidth: .infinity)
                .frame(height: 400)
        }
    }




struct Challenge1View: View{
    
    
    
    var body: some View {
        Image(systemName: "house")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50, alignment: .center)
    }
}
















#Preview {
    ChallengesView()
}
