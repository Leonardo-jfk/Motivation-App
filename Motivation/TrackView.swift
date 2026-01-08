//
//  TrackView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 06/01/2026.
//

import Foundation
import SwiftUI
import Lottie


struct TrackView: View {
    @State private var showingQuote = false
    @State private var currentRandomQuote: String = ""
    
    // Aquí usamos AppStorage para guardar los días practicados de forma permanente
    @AppStorage("daysPracticed") private var daysPracticed: Int = 0
    
    // Animación de Lottie
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .playOnce
    
    var body: some View {
        ZStack {
            // Fondo con Lottie
            LottieView(animation: .named("MeteorBack"))
                .configure({ lottie in lottie.contentMode = contentMode })
                .playbackMode(.playing(.toProgress(1, loopMode: .loop))) // .loop para que el fondo se mueva siempre
                .resizable()
                .ignoresSafeArea()
                        if !showingQuote {
            VStack(spacing: 30) {
                // Contador de días
                VStack {
                    Text("\(daysPracticed)")
                        .font(.system(size: 80, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                    
                    Text("Days lived mindfully")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }
            
            
            Spacer()
            
            // Botón para obtener sabiduría
            if !showingQuote {
//                Spacer()
                Button(action: {
                    // Seleccionamos la cita aleatoria antes de mostrarla
                    currentRandomQuote = quotesLongEng.randomElement() ?? "Sigue adelante."
                    withAnimation(.spring()) {
                        showingQuote = true
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 250, height: 100)
                        
                        Text("Get guidance".localized)
                            .font(.title3).bold().foregroundStyle(.white)
                    }
                }
            } else {
                // Vista de la cita desplegada
                VStack(spacing: -20) {
                    //                        AnimationView() // Tu vista de Lottie de la chica
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 40, style: .continuous)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 350, height: 700)
                        
                        VStack(spacing: 20) {
                            Text("Your guidance:".localized)
                                .font(.title2).bold()
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(.white.opacity(0.2))
                                .clipShape(Capsule())
                                .foregroundStyle(.white)
                                .padding(.top, 50)
                            Spacer()
                            ScrollView {
                                Text(currentRandomQuote)
                                    .font(.custom("CormorantGaramond-Italic", size: 22))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                    .padding()
                            }
                            .frame(height: 400)
                            
                            // Botón para marcar día como completado
                            Button(action: {
                                daysPracticed += 1
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                withAnimation { showingQuote = false }
                            }) {
                                Text("Mark day as mindful")
                                    .bold()
                                    .padding()
                                    .background(.white)
                                    .foregroundStyle(.black)
                                    .clipShape(Capsule())
                            
                        }
                            .padding(.bottom, 50)
                    }
                }
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
            
            Spacer()
        }
//        .padding(.bottom, 100) // Espacio para la TabBar
    }
//        .padding(.bottom, 100) // Espacio para la TabBar
    }
}

    
    struct DayCountChanger {
        //counting user days of practise
    }

#Preview {
    TrackView()
}




























//f
