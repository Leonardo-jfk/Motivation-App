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
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.black.opacity(0.8))
                        .frame(width: 100, height: 100)

                    Text("Hello, world!")
                        .font(.caption2)
                        .foregroundStyle(.white)
                }
                .padding()
            })
        }
        if showingQuote == true {
            show: quoteDiscription()
        }
                
        
    }
}

// Vista de la descripción de la cita
struct quoteDiscription: View {
    let currectDate: Int = 1
    
    var body: some View {
        let discriptionView = ZStack {
            
            
            VStack(spacing: 15) {
                Text("discribe the world")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                
                // Ejemplo de contenido adicional
                Text("Contenido del día \(currectDate)")
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.8))
            }
            
        }
//        Button("Close"){
//            onDismiss()
//        }
//        DialogExample(onDismissOutside: true, closeDialog: {
//            clearFrom()
//        }, content: discriptionView)
    }
}
#Preview {
        ContentView()
    }
