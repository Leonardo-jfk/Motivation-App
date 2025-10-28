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
                        .frame(width: 200, height: 200)

                    Text("Hello, world!")
                        .font(.caption2)
                        .foregroundStyle(.white)
                }
                .padding()
            })
        }
        .sheet(isPresented: $showingQuote) {
            quoteDiscription()
                .presentationDetents([.medium]) // Grande; puedes usar [.medium, .large]
        }
    }
}

// Vista de la descripción de la cita
struct quoteDiscription: View {
    let currectDate: Int = 1

    var body: some View {
        let discriptionView = ZStack {
           

            VStack(spacing: 16) {
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
        DialogExample(onDismissOutside: true, closeDialog: {
                            clearFrom()
                        }, content: discriptionView)
    }
}

#Preview {
    ContentView()
}
