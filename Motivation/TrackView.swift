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
    
    @StateObject private var langManager = LocalizationManager.shared
    
    // Aquí usamos AppStorage para guardar los días practicados de forma permanente
    @AppStorage("daysPracticed") private var daysPracticed: Int = 0
    @AppStorage("lastDatePracticed") private var lastDatePracticed: String = ""
    // Animación de Lottie
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .playOnce
    
    var onAnimationDidFinish: (() -> Void)? = nil
    
    func canIncrementCounter() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = formatter.string(from: Date())
        
        // Si la fecha guardada es distinta a la de hoy, puede sumar
        return lastDatePracticed != currentDateString
    }
    
    let allQuotes: [AppLanguage: [String]] = [
        .english: quotesLongEng,
        .spanish: quotesLongES,
        .french: quotesLongFr // O como se llamen tus otras listas
    ]
    
    
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
                        
                        Text("Days lived mindfully".localized)
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
                        .transition(.opacity)
                    
                    Spacer()
                    // Botón para obtener sabiduría
                    Button(action: {
                        // Seleccionamos la cita aleatoria antes de mostrarla
                        //                        currentRandomQuote = quotesLongEng.randomElement() ?? "Sigue adelante."
                        
                        let currentLang = langManager.currentLanguage
                        
                        // 2. Buscamos el array correspondiente (usamos inglés como fallback)
                        let selectedQuotes = allQuotes[currentLang] ?? quotesLongEng
                        
                        // 3. Seleccionamos la cita
                        currentRandomQuote = selectedQuotes.randomElement() ?? "..."
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
                    VStack(alignment: .center, spacing: -20) {
                        //                        AnimationView() // Tu vista de Lottie de la chica
                        
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 40, style: .continuous)
                                .fill(Color.black.opacity(0.5))
                                .frame(width: 350, height: 700)
                            
                            VStack{
                                //.padding(.top, 50) and button are optimal for 16e, max needs more
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
                                        .padding(.horizontal, 95)
                                    
//                                        .frame(maxWidth: .infinity - 70)
                                        .font(.custom("CormorantGaramond-Italic", size: 22))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.white)
                                                                        }
                                .frame(height: 400)
                                
                                
                                Spacer()
                                
                                Button(action: {
                                    if canIncrementCounter() {
                                        // PRIMERA VEZ HOY: Sumamos y animamos
                                        daysPracticed += 1
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yyyy-MM-dd"
                                        lastDatePracticed = formatter.string(from: Date())
                                        
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        
                                        // Mostramos al Ninja
                                        showNinjatoAnimation = true
                                        ninjatoPlayback = .playing(.toProgress(1, loopMode: .playOnce))
                                    } else {
                                        // YA SUMÓ HOY: El botón sirve para CERRAR la vista
                                        withAnimation {
                                            showingQuote = false
                                            showNinjatoAnimation = false
                                        }
                                    }
                                }) {
                                    Text(canIncrementCounter() ? "Mark day as mindful".localized : "Return to peace")
                                        .bold()
                                        .padding()
//                                        .frame(maxWidth: .infinity)
                                        .background(canIncrementCounter() ? .white : .white.opacity(0.7))
                                        .foregroundStyle(.black)
                                        .clipShape(Capsule())
                                        .allowsHitTesting(false)
                                        .padding(.bottom, 50)
                                }
                                
                                
                                
                            }
                        }
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    }
                    
                    Spacer()
                }
                   
                    
                                }
            if showNinjatoAnimation {
                            LottieView(animation: .named("Ninjato"))
                    .configure({ lottie in lottie.contentMode = .scaleAspectFit
                        lottie.animationSpeed = 0.4
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
//        .padding(.bottom, 100) // Espacio para la TabBar
    }
//        .padding(.bottom, 100) // Espacio para la TabBar
    }
}

//func canIncrementCounter() -> Bool {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd"
//    let currentDateString = formatter.string(from: Date())
//
//    // Si la fecha guardada es distinta a la de hoy, puede sumar
//    return lastDatePracticed != currentDateString
//}





#Preview {
    TrackView()
}












//f

