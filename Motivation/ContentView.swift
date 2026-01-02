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
    
    public var body: some View {
//        LottieAnimation(fileName: "books", config: AnimationConfig(autoplay: true, loop: true)).view()
        LottieView(animation: .named("books"))
        Text("here")
    }
    

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
        return QuoteLibrary.FavoriteStorage.load()
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
                    
                    
                    VStack {
                        // Spacer to push main content below the nav bar if needed
                        Spacer()
                        // Botón que abre la descripción
                        Button(action: {
                            showingQuote.toggle()
                        }, label: {
                            if showingQuote {
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
                                    .padding()
                                }
                                .padding()
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
                                
                            }
                        })
//                        Spacer()
                        AnimationView()
                    }
                }
//                .id(appScheme.rawValue + (showingQuote ? "quote" : "button"))
//                // This prevents navigation reset when color scheme changes
////                .preferredColorScheme(appScheme.preferredColorScheme)
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
                }
                
                .onReceive(NotificationCenter.default.publisher(for: .didPerformFullReset)) { _ in
                    favoriteQuotes = []
                }
            
            }
            
            .environmentObject(navManager) 
            
            
            //                .onReceive(NotificationCenter.default.publisher(for: .didPerformFullReset)) { _ in
            //        favoriteQuotes = []
//            .id(appScheme.rawValue + (showingQuote ? "quote" : "button"))
//            // This prevents navigation reset when color scheme changes
////                .preferredColorScheme(appScheme.preferredColorScheme)
//            .preferredColorScheme(appScheme.preferredColorScheme)
//            .preferredColorScheme(appScheme.preferredColorScheme)
//        .id(l10n.currentLanguage)
    }
//        .id(l10n.currentLanguage))
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

#Preview {
    ContentView()
}

