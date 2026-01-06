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
            LottieView(animation: .named("MeteorBack"))
                .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
                })
                .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
                .animationDidFinish { completed in onAnimationDidFinish?()
                }
                .resizable()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(alignment: .center ) {
                Text("Days that your lived mindfully")
                    .font(.largeTitle)
                    .bold()
                    .padding(20)
                    .frame(maxWidth: 250)
                    .background(
                        Color.gray
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .opacity(0.6))
                
                
                
                //func with the count
                
                
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        showingQuote.toggle()
                    }
                }) {
                    if showingQuote {
                        VStack(spacing: 0) {
                            AnimationView()
                            ZStack {
                                RoundedRectangle(cornerRadius: 40, style: .continuous)
                                    .fill(Color.black.opacity(0.8))
                                    .frame(width: 350, height: 350)
                                
                                VStack {
                                    Text("Your guidence:".localized)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.gray.opacity(0.4))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                    
                                    QuoteLongRandom( currentQuote: currentQuote)
                                        .padding(.horizontal)
                                        .frame(maxWidth: 350, maxHeight: 300)
                                    
                                    Button(action) {
                                        withAnimation(.spring()) {
                                            DayCountChanger.toggle()
                                        }
                                    }
                                }
                            }
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(Color.black.opacity(0.8))
                                    .frame(width: 220, height: 110)
                                
                                Text("Get today's wisdom".localized)
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                        }
                        //                })
                    }
                    
                    
                    
                    
                    
                    Image(systemName: "heart").resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    // Your future challenges logic here
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct QuoteLongRandom {
    
    let currentQuote: [String]
    let text: String = {
        currentQuote.randomElement(QuotesLong.quotesLongEng)
    }
}
    
struct DayQuoteView: View {
    let index: Int
    let currentQuotes: [String]
    
    var body: some View {
        let text: String = {
            guard !currentQuotes.isEmpty else { return "No quotes available.".localized }
            let safeIndex = max(0, min(index, currentQuotes.count - 1))
            return currentQuotes[safeIndex]
        }()
        
        return Text(text)
            .font(.custom("CormorantGaramond-Italic", size: 28))
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
            .padding(.vertical, 60)
    }
}
    
    
    struct DayCountChanger {
        //counting user days of practise
    }

#Preview {
    TrackView()
}
