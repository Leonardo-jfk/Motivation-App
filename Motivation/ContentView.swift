//
//  ContentView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 04/10/2025.
//

import Foundation
import SwiftUI
import UserNotifications
import Combine
//import DotLottie
import Lottie




// Helper: día del año (1...365/366)
func dayOfYear(for date: Date = .now) -> Int {
    let calendar = Calendar.current
    return calendar.ordinality(of: .day, in: .year, for: date) ?? 1
}



class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func reset() {
        path = NavigationPath()
    }
}


public struct AnimationView: View {
    var fileName: String = "Girl with books"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .playOnce
    var onAnimationDidFinish: (() -> Void)? = nil
    
    public var body: some View {
        //        Text("books should be here")
//        VStack(spacing: 0){
            LottieView(animation: .named(fileName))
                .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
                })
                .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
                .animationDidFinish { completed in onAnimationDidFinish?()
                }
                .frame(width: 150, height: 150)
        }
//    }
}

//for CustomTabBar
enum Tab: Int {
    case today = 0
    case practice = 1
    case challenges = 2
    case quotes = 3
    case settings = 4
}

struct ContentView: View {
    
    @StateObject private var navManager = NavigationManager()
    
    
    @State private var showingQuote = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    private var appScheme: AppColorScheme {
        AppColorScheme(rawValue: storedScheme) ?? .system
    }
    // Source of truth for favorites - load from storage on init
    @State public var favoriteQuotes: Set<String> = {
        return FavoriteStorage.load()
    }()
    
    @StateObject public var l10n = LocalizationManager.shared
    
    public var currentQuotes: [String] {
        switch l10n.currentLanguage {
        case .english:
            return quotesEng
        case .spanish:
            return quotesES
        case .french:
            return quotesFR
        }
    }
        private var todayIndex: Int {
            let day = dayOfYear() // 1-based
            guard !currentQuotes.isEmpty else { return 0 }
            return (day - 1) % currentQuotes.count
        }
        
    @State private var selectedTab: Tab = .challenges
    
        
        var body: some View {
            
            
            // Wrap the whole interactive content in a single NavigationStack
            NavigationStack(path: $navManager.path) {
                ZStack{
                    if colorScheme == .dark {
                        Image(.backgroundDark)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else{
                        Image(.backgroundLight)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    
                    VStack(spacing: 0){
                        // Spacer to push main content below the nav bar if needed
                        Spacer()
                        // Botón que abre la descripción
                        Button(action: {
                            showingQuote.toggle()
                        }, label: {
                            if showingQuote {
                                VStack(spacing: 0){
                                
                                AnimationView()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                                        .fill(Color.black.opacity(0.8))
                                        .frame(width: 350, height: 350)
                                    
                                    VStack {
                                        Text("Today's wisdom dose:".localized)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(.gray.opacity(0.4))
                                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                        
                                        DayQuoteView(index: todayIndex, currentQuotes: currentQuotes)
                                            .padding(.horizontal)
                                            .frame(maxWidth: 350, maxHeight: 300)
                                            .font(.custom("CormorantGaramond-Italic", size: 24))
                                    }
                                    .padding(.top, 0)
                                }
                                .padding(.top, 0)
                            }
//                                .preferredColorScheme(appScheme.preferredColorScheme)
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .fill(Color.black.opacity(0.8))
                                        .frame(width: 200, height: 100)
                                    
                                    Text("Get today's wisdom ".localized)
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                        .background(.gray.opacity(0.5))
                                }
                                .padding()
                                
                                NavigationLink(destination: SettingsList()){}
//                                Spacer()
                            }
                            
                        })
                        Spacer()
                    }
                    ZStack(alignment: .bottom) {
                                // Your Main Content
                        Group {
                                                switch selectedTab {
                                                case .challenges:
                                                    ChallengesView()
                                                case .today:
                                                    Text("Today Screen") // Replace with your TodayView
                                                default:
                                                    Text("Other Screen")
                                                }
                                            }
                                
                                // The Toolbar
                                CustomTabBar(selectedTab: $selectedTab)
                            }
                            .ignoresSafeArea(edges: .bottom)
                }
                .preferredColorScheme(appScheme.preferredColorScheme)
                

                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(destination: QuoteLibrary(favoriteQuotes: $favoriteQuotes)) {
                            Image(systemName: "apple.books.pages")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.primary)
                                .padding(15) // touch target
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: HouseMenu()) {
                            Image(systemName: "house")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.primary)
                                .padding(15) // touch target
                        }
                    }
                    
//                    ToolbarItem(placement: .bottomBar) {
//                        NavigationLink(destination: HouseMenu()) {
//                            Image(systemName: "house")
//                                .resizable()
//                                .frame(width: 35, height: 35)
//                                .foregroundStyle(.primary)
//                                .padding(15) // touch target
//                        }
//                    }
                }
                
                .onReceive(NotificationCenter.default.publisher(for: .didPerformFullReset)) { _ in
                    favoriteQuotes = []
                }
            
            }
            
            .environmentObject(navManager) 
            
    }
}
    // A small view that safely shows the quote for a given index.
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



struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    // Define your tabs
    let tabs = [
        ("Today", "sun.max"),
        ("Practice", "figure.mindful.relaxing"),
        ("Challenges", "list.bullet.indent"),
        ("Quotes", "book"),
        ("Settings", "gearshape")
    ]
    
//    enum Tab: Int {
//        case today = 0
//        case practice = 1
//        case challenges = 2
//        case quotes = 3
//        case settings = 4
//    }
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Spacer()
                
                Button(action: { selectedTab = index }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].1)
                            .font(.system(size: 22))
                        
                        Text(tabs[index].0)
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == index ? .black : .secondary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    // The "Pill" effect for the active tab
                    .background(
                        Capsule()
                            .fill(selectedTab == index ? Color.gray.opacity(0.15) : Color.clear)
                    )
                }
                
                Spacer()
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 34) // Padding for iPhone "Home Bar" area
        .background(.ultraThinMaterial) // Translucent glass effect
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}



#Preview {
    ContentView()
}

