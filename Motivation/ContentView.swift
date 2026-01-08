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
        VStack{

            LottieView(animation: .named(fileName))
                .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
                })
                .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
                .animationDidFinish { completed in onAnimationDidFinish?()
                }
                .frame(width: 150, height: 150)
        }
    }
}

//for CustomTabBar
enum Tab: Int {
    case today = 0
    case track = 1
    case challenges = 2
    case goals = 3
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
        
        NavigationStack(path: $navManager.path) {
            ZStack(alignment: .bottom) {
                backgroundLayer
                Group {
                    switch selectedTab {
                    case .today:
                        TodayView(showingQuote: $showingQuote, todayIndex: todayIndex, currentQuotes: currentQuotes, favoriteQuotes: $favoriteQuotes)
                    case .challenges:
                        ChallengesView()
                    case .track:
                        TrackView()
                    case .goals:
                        GoalsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // Add padding to the bottom of the views so content doesn't
                // hide behind the TabBar. 80-100 is usually a good range.
                .padding(.bottom, 70)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
            
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
        ("Goal", "flame", .goals),
        ("Challenge", "figure.archery", .challenges),
    ]
    
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(tabs, id: \.name) { tab in
             
                Spacer(minLength: 0)
                
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
//                    .frame(width: 75)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
//                    .ignoresSafeArea()
                    // The "Pill" effect for the active tab
                    .background(
                        Capsule()
                            .fill(selectedTab == tab.type ? Color.gray.opacity(0.25) : Color.clear)
                            .shadow(color: Color.black.opacity(0.45), radius: 10, x: 0, y: 5)
//                            .frame(minWidth: .infinity)
                    )
                }
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 45) // This keeps buttons away from the screen edges
                .padding(.top, 8)
                .padding(.bottom, 10)
        .background(.ultraThinMaterial) // Translucent glass effect
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: Color.black.opacity(0.45), radius: 10, x: 0, y: 5)
//        .ignoresSafeArea(edges: .bottom)
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
                            .frame(height: 110)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 70)
                        
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
            
        }
        
    }
}

#Preview {
    ContentView()
}

