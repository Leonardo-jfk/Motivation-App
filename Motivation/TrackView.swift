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
    @State private var showNinjatoAnimation = false // Nuevo estado para la animación
    @State private var ninjatoPlayback: LottiePlaybackMode = .paused(at: .progress(0))
    
    // Aquí usamos AppStorage para guardar los días practicados de forma permanente
    @AppStorage("daysPracticed") private var daysPracticed: Int = 0
    
    // Animación de Lottie
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .playOnce
    
    var onAnimationDidFinish: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Fondo con Lottie
            LottieView(animation: .named("MeteorBack"))
                .configure({ lottie in lottie.contentMode = contentMode })
                .playbackMode(.playing(.toProgress(1, loopMode: .loop))) // .loop para que el fondo se mueva siempre
                .resizable()
                .ignoresSafeArea()
            
                VStack(alignment: .center) {
                if !showingQuote {
                    //            VStack(spacing: 30) {
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
                    //        }
                    
                    LottieView(animation: .named("Japan Flow"))
            .configure({ lottie in lottie.contentMode = .scaleAspectFit
                lottie.animationSpeed = 0.5
            })
                        .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                        .animationDidFinish { completed in
                            // Cuando termina la animación, cerramos todo
                            withAnimation {
                                showNinjatoAnimation = false
                                showingQuote = false
//                                ninjatoPlayback = .paused(at: .progress(0))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 300) // Ajusta el tamaño que desees
                        .transition(.opacity)
                    
                    Spacer()
                    if showNinjatoAnimation {
                                    LottieView(animation: .named("Ninjato"))
                            .configure({ lottie in lottie.contentMode = .scaleAspectFit
                                lottie.animationSpeed = 0.5
                            })
                                        .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                                        .animationDidFinish { completed in
                                            // Cuando termina la animación, cerramos todo
                                            withAnimation {
                                                showNinjatoAnimation = false
                                                showingQuote = false
                                                ninjatoPlayback = .paused(at: .progress(0))
                                            }
                                        }
                                        .frame(width: 300, height: 300) // Ajusta el tamaño que desees
                                        .transition(.opacity)
                                }
                    // Botón para obtener sabiduría
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
                        .padding(.bottom, 50)
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
                                    Text(currentRandomQuote.localized)
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
                                    showNinjatoAnimation = true
                                    ninjatoPlayback = .playing(.toProgress(1, loopMode: .playOnce))
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
                   
                    
                                }
//        .padding(.bottom, 100) // Espacio para la TabBar
    }
//        .padding(.bottom, 100) // Espacio para la TabBar
    }
}







#Preview {
    TrackView()
}












//f

