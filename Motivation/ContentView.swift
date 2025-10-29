//
//  ContentView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 04/10/2025.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var showingQuote = false

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
                        RoundedRectangle(cornerRadius: 40, style: .continuous)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 350, height: 350)
                        
                        Text("discribe th eworld correctly")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }
                    .padding()
                } else{
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 100, height: 100)
                        
                        Text("Hello, world!")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }
                    .padding()
                }})
                   
        }//.sheet(isPresented: $showingQuote) { quoteDiscription() }
                
//        if showingQuote == true {
//            ZStack {
//                RoundedRectangle(cornerRadius: 40, style: .continuous)
//                    .fill(Color.black.opacity(0.8))
//                    .frame(width: 300, height: 300)
//
//                Text("discribe th eworld correctly")
//                    .font(.caption2)
//                    .foregroundStyle(.white)
//            }
//            .padding()
//        }
    }
        
    
}


#Preview {
        ContentView()
    }
