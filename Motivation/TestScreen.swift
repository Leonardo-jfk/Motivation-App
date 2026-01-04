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
    var fileName1: String = "GymBro"
    var fileName2: String = "Loading"
    var fileName3: String = "MessageSent"
    var fileName4: String = "Meditation Skull"
    var fileName5: String = "Menorah"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .playOnce
    
    var onAnimationDidFinish: (() -> Void)? = nil
    
    var body: some View {
        AnimationView()
        Text("books should be here")
        LottieView(animation: .named(fileName1))
            .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
            })
            .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
            .animationDidFinish { completed in onAnimationDidFinish?()
            }
            .frame(width: 100, height: 100)
        
        
        LottieView(animation: .named(fileName2))
            .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
            })
            .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
            .animationDidFinish { completed in onAnimationDidFinish?()
            }
            .frame(width: 300, height: 100)
            .scaledToFit()
        
        
        LottieView(animation: .named(fileName3))
            .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
            })
            .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
            .animationDidFinish { completed in onAnimationDidFinish?()
            }
            .frame(width: 200, height: 100)
            .scaledToFit()
        
        LottieView(animation: .named(fileName4))
            .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
            })
            .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
            .animationDidFinish { completed in onAnimationDidFinish?()
            }
        
            .frame(width: 200, height: 100)
            .scaledToFit()
        
        
        LottieView(animation: .named(fileName5))
            .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
            })
            .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
            .animationDidFinish { completed in onAnimationDidFinish?()
            }
            .resizable()
            .frame(width: 200, height: 100)
            .scaledToFit()
    }
}
#Preview {
    TestScreenView()
}

