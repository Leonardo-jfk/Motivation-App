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
        // Map to 0...(quotes.count - 1) by modulo, guarding empty array.
        guard !quotes.isEmpty else { return 0 }
        return (day - 1) % quotes.count
    }

    var body: some View {
        ZStack {
            // Fondo
            Image(.backgroundDark)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            //                    NavigationStack{
            //                        List{
            //                            NavigationLink(destination:QuoteLibrary()){
            //                                Text("Full library ")
            //                            }
            Button(action:{
                NavigationLink(destination: QuoteLibrary()){
                    Text("Fav Places")
                }
//        }
            }, label:{
                ZStack {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.black.opacity(0.8))
                        .frame(width: 50, height: 50)
                    Image(systemName: "apple.books.pages")
                        .resizable()
                })
            // Botón que abre la descripción
            Button(action: {
                showingQuote.toggle()
            }
                   , label: {
                if showingQuote {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40, style: .continuous)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 350, height: 350)

                        VStack {
                            Spacer()
                            Spacer()
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
                                
                            Spacer()
                            Spacer()
                        }
                        .padding()
                    }
                    .padding()
                }
                    else {
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
            })//.frame(width: 5, height: 5)
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
