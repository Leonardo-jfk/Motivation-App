//
//  TrackView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 06/01/2026.
//

import Foundation
import SwiftUI
import Lottie


//public struct TrackView: View {
//    
////    var fileName: String = "Girl with books"
//    var contentMode: UIView.ContentMode = .scaleAspectFill
//    var playLoopMode: LottieLoopMode = .playOnce
//    var onAnimationDidFinish: (() -> Void)? = nil
//    
//    
//    public var body: some View {
//        ZStack{
//            LottieView(animation: .named("MeteorBack"))
//                .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
//                })
//                .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
//                .animationDidFinish { completed in onAnimationDidFinish?()
//                }
//                .resizable()
//                .ignoresSafeArea()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            
//            VStack(alignment: .center ) {
//                Text("Days that your lived mindfully")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(20)
//                    .frame(maxWidth: 250)
//                    .background(
//                        Color.gray
//                            .clipShape(RoundedRectangle(cornerRadius: 30))
//                            .opacity(0.6))
//                
//                
//                
//                //func with the count
//                
//                
//                
//                Spacer()
//                
//                Button(action: {
//                    withAnimation(.spring()) {
//                        showingQuote.toggle()
//                    }
//                }) {
//                    if showingQuote {
//                        VStack(spacing: 0) {
//                            AnimationView()
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 40, style: .continuous)
//                                    .fill(Color.black.opacity(0.8))
//                                    .frame(width: 350, height: 350)
//                                
//                                VStack {
//                                    Text("Your guidence:".localized)
//                                        .padding(.horizontal, 8)
//                                        .padding(.vertical, 4)
//                                        .background(.gray.opacity(0.4))
//                                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                                        .font(.title2)
//                                        .foregroundStyle(.white)
//                                    
//                                    QuoteLongRandom( currentQuote: currentQuote)
//                                        .padding(.horizontal)
//                                        .frame(maxWidth: 350, maxHeight: 300)
//                                    
//                                    Button(action) {
//                                        withAnimation(.spring()) {
//                                            DayCountChanger.toggle()
//                                        }
//                                    }
//                                }
//                            }
//                        } else {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 30, style: .continuous)
//                                    .fill(Color.black.opacity(0.8))
//                                    .frame(width: 220, height: 110)
//                                
//                                Text("Get today's wisdom".localized)
//                                    .font(.title3)
//                                    .bold()
//                                    .foregroundStyle(.white)
//                            }
//                        }
//                        //                })
//                    }
//                    
//                    
//                    
//                    
//                    
//                    Image(systemName: "heart").resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                    // Your future challenges logic here
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//        }
//    }
//}

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
                
                Spacer()

                // Botón para obtener sabiduría
                if !showingQuote {
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
                        AnimationView() // Tu vista de Lottie de la chica
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 40, style: .continuous)
                                .fill(Color.black.opacity(0.9))
                                .frame(width: 350, height: 400)
                            
                            VStack(spacing: 20) {
                                Text("Your guidance:".localized)
                                    .font(.caption).bold()
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(.white.opacity(0.2))
                                    .clipShape(Capsule())
                                    .foregroundStyle(.white)

                                ScrollView {
                                    Text(currentRandomQuote)
                                        .font(.custom("CormorantGaramond-Italic", size: 22))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.white)
                                        .padding()
                                }
                                .frame(height: 200)

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
                            }
                            .padding()
                        }
                    }
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
                
                Spacer()
            }
            .padding(.bottom, 100) // Espacio para la TabBar
        }
    }
}

    
//struct DayQuoteView: View {
//    let index: Int
//    let currentQuotes: [String]
//    
//    var body: some View {
//        let text: String = {
//            guard !currentQuotes.isEmpty else { return "No quotes available.".localized }
//            let safeIndex = max(0, min(index, currentQuotes.count - 1))
//            return currentQuotes[safeIndex]
//        }()
//        
//        return Text(text)
//            .font(.custom("CormorantGaramond-Italic", size: 28))
//            .multilineTextAlignment(.center)
//            .foregroundStyle(.white)
//            .padding(.vertical, 60)
//    }
//}
    
    
    struct DayCountChanger {
        //counting user days of practise
    }

#Preview {
    TrackView()
}

