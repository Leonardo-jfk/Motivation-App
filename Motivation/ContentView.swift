//
//  ContentView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 04/10/2025.
//

import Foundation
import SwiftUI

// Helper: día del año (1...365/366)
func dayOfYear(for date: Date = .now) -> Int {
    let calendar = Calendar.current
    return calendar.ordinality(of: .day, in: .year, for: date) ?? 1
}

struct ContentView: View {
    @State private var showingQuote = false

    // Use 0-based index for arrays; clamp to valid range based on quotes.count.
    private var todayIndex: Int {
        let day = dayOfYear() // 1-based
        guard !quotes.isEmpty else { return 0 }
        return (day - 1) % quotes.count
    }

    var body: some View {
        

            // Wrap the whole interactive content in a single NavigationStack
            NavigationStack {
                ZStack{
                Image(.backgroundDark)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
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
                                        Text("Today's wisdom dose:")
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(.gray.opacity(0.4))
                                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                        
                                        DayQuoteView(index: todayIndex)
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
                                    
                                    Text("Get today's wisdom ")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                        .background(.gray.opacity(0.5))
                                }
                                .padding()
                            }
                        })
                        Spacer()
                    }
                }
               
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(destination: QuoteLibrary()) {
                            Image(systemName: "apple.books.pages")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.primary)
                                .padding(10) // touch target
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: QuoteLibrary()) {
                            Image(systemName: "apple.books.pages")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.primary)
                                .padding(10) // touch target
                        }
                    }
                }
             
            }
    }
}

// A small view that safely shows the quote for a given index.
struct DayQuoteView: View {
    let index: Int

    var body: some View {
        let text: String = {
            guard !quotes.isEmpty else { return "No quotes available." }
            let safeIndex = max(0, min(index, quotes.count - 1))
            return quotes[safeIndex]
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
