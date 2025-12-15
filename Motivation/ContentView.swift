//
//  ContentView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 04/10/2025.
//

import Foundation
import SwiftUI
import quotes from QuoteLibrary

// Helper: día del año (1...365/366)
func dayOfYear(for date: Date = .now) -> Int {
    let calendar = Calendar.current
    return calendar.ordinality(of: .day, in: .year, for: date) ?? 1
}

struct ContentView: View {
    @State private var showingQuote = false
    var quote_id = dayOfYear()
    
    var body: some View {
        ZStack {
            // Fondo
            Image(.backgroundDark)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Botón que abre la descripción
            Button(action: {
                showingQuote = true
            }, label: {
                if showingQuote == true {
                    ZStack {
                        ZStack{
                            RoundedRectangle(cornerRadius: 40, style: .continuous)
                                .fill(Color.black.opacity(0.8))
                                .frame(width: 350, height: 350)
                        }
                        VStack{
                            Spacer()
                            Text("Today's wisdom dose:")
                                .background(.gray)
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                            Spacer()
                            
                            // Inserta el componente que carga y muestra la cita:
                            findQuotesApi()
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                    .padding()
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 100, height: 100)
                        
                        Text("Hello, world!")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }
                    .padding()
                }
            })
        }
        //.sheet(isPresented: $showingQuote) { quoteDiscription() }
    }
}

struct findQuotesApi: View {
  
}

#Preview {
    ContentView()
}
