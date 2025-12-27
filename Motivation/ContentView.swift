//
//  ContentView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 04/10/2025.
//

import Foundation
import SwiftUI
import UserNotifications




// Helper: día del año (1...365/366)
func dayOfYear(for date: Date = .now) -> Int {
    let calendar = Calendar.current
    return calendar.ordinality(of: .day, in: .year, for: date) ?? 1
}

struct ContentView: View {
    @State private var showingQuote = false
    @Environment(\.colorScheme) var colorScheme
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
        }
    }
        private var todayIndex: Int {
            let day = dayOfYear() // 1-based
            guard !currentQuotes.isEmpty else { return 0 }
            return (day - 1) % currentQuotes.count
        }
        
        
        
        
        var body: some View {
            
            
            // Wrap the whole interactive content in a single NavigationStack
            NavigationStack {
                ZStack{
                    if colorScheme == .dark {
                        Image(.backgroundDark)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    }
                    else{
                        Image(.backgroundLight)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    }
                    
                    
                    VStack {
                        // Spacer to push main content below the nav bar if needed
                        Spacer(minLength: 0)
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
                                    }
                                    .padding()
                                }
                                .padding()
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
                        Spacer()
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
                
                .onReceive(NotificationCenter.default.publisher(for: .didPerformFullReset)) { _ in
                    favoriteQuotes = []
                }
            }
            //                .onReceive(NotificationCenter.default.publisher(for: .didPerformFullReset)) { _ in
            //        favoriteQuotes = []
        
        .id(l10n.currentLanguage)
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
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.vertical, 60)
        }
    }

#Preview {
    ContentView()
}
