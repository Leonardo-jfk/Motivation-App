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

enum MainNavigation: Hashable {
    case track
    case challenges
    case goals
    // Add other cases as needed in future
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
    case track = 1
    case challenges = 2
    case goals = 3
//    case settings = 4
}

struct ContentView: View {
    @StateObject private var navManager = NavigationManager()
    @State private var selectedTab: Tab = .today // Default to Today
    @State private var showingQuote = false
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    
    // Quotes logic stays here or in a ViewModel
    @State public var favoriteQuotes: Set<String> = FavoriteStorage.load()
    @StateObject public var l10n = LocalizationManager.shared

    var currentQuotes: [String] {
        switch l10n.currentLanguage {
        case .english: return quotesEng
        case .spanish: return quotesES
        case .french: return quotesFR
        }
    }
    
    private var todayIndex: Int {
        let day = dayOfYear()
        return currentQuotes.isEmpty ? 0 : (day - 1) % currentQuotes.count
    }

    var body: some View {
        //        NavigationStack(path: $navManager.path) {
        //            ZStack {
        //                // Background
        //                backgroundLayer
        //
        //                VStack(spacing: 0) {
        //                    // PAGE ROUTER
        //                    Group {
        //                        switch selectedTab {
        //                        case .today:
        //                            TodayView(showingQuote: $showingQuote,
        //                                      todayIndex: todayIndex,
        //                                      currentQuotes: currentQuotes,
        //                                      favoriteQuotes: $favoriteQuotes)
        //                        case .challenges:
        //                            ChallengesView()
        //                        case .track:
        //                            Text("Track / Practice View")
        //                        case .goals:
        //                            Text("Goals View")
        //                        case .settings:
        //                            SettingsList()
        //                        }
        //                    }
        //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
        //                    .transition(.opacity) // Smooth fade between tabs
        //
        //                    // TAB BAR
        //                    CustomTabBar(selectedTab: $selectedTab, onPracticeTap: {
        //                        navManager.path.append(MainNavigation.track)
        //                        navManager.path.append(MainNavigation.challenges)
        //                        navManager.path.append(MainNavigation.goals)
        //                    })
        //                    .padding(.horizontal)
        //                    .padding(.bottom, 10)
        //                }
        //            }
        //
        //        }
        
        
        NavigationStack(path: $navManager.path) {
            ZStack {
                backgroundLayer
                
                VStack(spacing: 0) {
                    Group {
                        switch selectedTab {
                        case .today:
                            TodayView(showingQuote: $showingQuote, todayIndex: todayIndex, currentQuotes: currentQuotes, favoriteQuotes: $favoriteQuotes)
                        case .challenges:
                            ChallengesView()
                        case .track:
                            Text("Track Viffffffdfffdfdfdfew")
                        case .goals:
                            GoalsView()
                            //                        case .settings:
                            //                            GoalsView()
                                                    }
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        CustomTabBar(selectedTab: $selectedTab) {
                            // If you want the button to "Push" a screen:
                            navManager.path.append(MainNavigation.track)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
                // FIX: Attach destination here, at the root level of the Stack content
                .navigationDestination(for: MainNavigation.self) { destination in
                    switch destination {
                    case .track:
                        TrackView()
                    case .challenges:
                        ChallengesView()
                    case .goals:
                        GoalsView()
                    }
                }
            }
            
            
            
            
            
            
            
        }
        
        // Background Helper
        var backgroundLayer: some View {
            Image(colorScheme == .dark ? .backgroundDark : .backgroundLight)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
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



struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    // Closure for practice tab tap
    var onPracticeTap: (() -> Void)? = nil
    
    // Define your tabs
    let tabs: [(name: String, icon: String, type: Tab)] = [
        ("Track", "tree", .track),
        ("Today", "sun.max", .today),
        ("Challenge", "figure.archery", .challenges),
        ("Goal", "flame", .goals),
    ]
    
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.name) { tab in
                Spacer()
                
                Button(action: {
                    selectedTab = tab.type
                    if tab.type == .track {
                        onPracticeTap?()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22))
                        
                        Text(tab.name)
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == tab.type ? .black : .secondary)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    // The "Pill" effect for the active tab
                    .background(
                        Capsule()
                            .fill(selectedTab == tab.type ? Color.gray.opacity(0.25) : Color.clear)
                    )
                }
                
                Spacer()
            }
        }
        .background(.ultraThinMaterial) // Translucent glass effect
        .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
    }
}

struct TodayView: View {
    @Binding var showingQuote: Bool
    let todayIndex: Int
    let currentQuotes: [String]
    @Binding var favoriteQuotes: Set<String>
    
    var body: some View {
        VStack(spacing: 0) {
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
                                Text("Today's wisdom dose:".localized)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.gray.opacity(0.4))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                
                                DayQuoteView(index: todayIndex, currentQuotes: currentQuotes)
                                    .padding(.horizontal)
                                    .frame(maxWidth: 350, maxHeight: 300)
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
            }
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
                
            }
            
            
            Spacer()
            
            //        .toolbar {
            //            ToolbarItem(placement: .topBarLeading) {
            //                NavigationLink(destination: QuoteLibrary(favoriteQuotes: $favoriteQuotes)) {
            //                    Image(systemName: "apple.books.pages")
            //                        .resizable()
            //                        .frame(width: 35, height: 35)
            //                        .foregroundStyle(.primary)
            //                        .padding(15) // touch target
            //                }
            //            }
            //            ToolbarItem(placement: .topBarTrailing) {
            //                NavigationLink(destination: HouseMenu()) {
            //                    Image(systemName: "house")
            //                        .resizable()
            //                        .frame(width: 35, height: 35)
            //                        .foregroundStyle(.primary)
            //                        .padding(15) // touch target
            //                }
            //            }
            //            
            //        }
            
        }
        
    }
}

#Preview {
    ContentView()
}

