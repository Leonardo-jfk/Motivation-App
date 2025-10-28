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
        }.sheet(isPresented: $showingQuote) { quoteDiscription() }
                
        
    }
}

// Vista de la descripción de la cita
struct quoteDiscription: View {
    var currectDate: Int = 5
    @Environment(\.dismiss) var dismiss
//    @Binding var showingQuote:Bool
    var body: some View {

            ZStack {
                
                
                VStack(spacing: 15) {
                    Button("come back")
                    {
                        dismiss()
                    }.frame(width: 100, height: 100)
                        .background(.mainSistem)
                    
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
//        }
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
