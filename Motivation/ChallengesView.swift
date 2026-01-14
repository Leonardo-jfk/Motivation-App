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
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    private var appScheme: AppColorScheme {
        AppColorScheme(rawValue: storedScheme) ?? .system
    }
    
    
    
    
    var fileName: String = "Girl with books"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .loop
    var onAnimationDidFinish: (() -> Void)? = nil
    
//    let BackImage = (colorScheme == .dark) ? "BackDarkMarco" : "BackLightMarco"
    
    public var body: some View {
        let backImage = (colorScheme == .dark) ? "BackDarkMarco" : "BackLightMarco"
//        Image("backImage")
//            .resizable()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        ZStack{
            Image(backImage)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            Rectangle()
                .frame(width:100, height: 200)
                .foregroundStyle(.white)
//            NavigationStack{
                
                
                VStack {
                    Text("Challenges List")
                        .font(.largeTitle)
                    Image(systemName: "book").resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Spacer() 
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width:150, height: 100)
                                .foregroundStyle(.gray)
                            NavigationLink("1st", destination:
                                            Challenge1View())
                        }
                        
                        ZStack{
                            Rectangle()
                                .frame(width:150, height: 100)
                                .foregroundStyle(.gray)
                            NavigationLink("1st", destination:
                                            Challenge2View())
                        }
                    }
                    
                    
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width:150, height: 100)
                                .foregroundStyle(.gray)
                            NavigationLink("1st", destination:
                                            Challenge1View())
                        }
                        
                        ZStack{
                            Rectangle()
                                .frame(width:150, height: 100)
                                .foregroundStyle(.gray)
                            NavigationLink("1st", destination:
                                            Challenge2View())
                        }
                        
                    }
                        
                        // Your future challenges logic here
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                }.frame(maxWidth: .infinity)
                    .frame(height: 400)
            }
        }
//    }
    
}

struct Challenge1View: View{
    
    
    
    var body: some View {
        Image(systemName: "house")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50, alignment: .center)
    }
}


struct Challenge2View: View{
    
    
    
    var body: some View {
        Image(systemName: "heart")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50, alignment: .center)
    }
}


struct Challenge3View: View{
    
    
    
    var body: some View {
        Image(systemName: "house")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50, alignment: .center)
    }
}


struct Challenge4View: View{
    
    
    
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
