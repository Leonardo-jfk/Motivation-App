//
//  ChallengesView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 05/01/2026.
//

import Foundation
import SwiftUI
import Lottie

public struct ChallengesView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    private var appScheme: AppColorScheme {
        AppColorScheme(rawValue: storedScheme) ?? .system
    }
    
    @State private var navigationPath = NavigationPath()
    
   public var body: some View {
        let backImage = (colorScheme == .dark) ? "BackDarkMarco" : "BackLightMarco"
        
        NavigationStack {
            ZStack {
                // Fondo
                Image(backImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Contenido principal
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 15) {
                            Text("Challenges List")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                            
                            // Estadísticas o información adicional
                            VStack(spacing: 15) {
                                Text("Your Progress")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                HStack(spacing: 30) {
                                    ProgressStat(
                                        value: "3",
                                        label: "Completed",
                                        color: .green
                                    )
                                    
                                    ProgressStat(
                                        value: "2",
                                        label: "In Progress",
                                        color: .yellow
                                    )
                                    
                                    ProgressStat(
                                        value: "5",
                                        label: "Available",
                                        color: .blue
                                    )
                                }
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                        }
                        .padding(.top, 40)
                        
                        // Grid de desafíos
                        VStack(spacing: 20) {
                            // Primera fila
                            HStack(spacing: 20) {
                                ChallengeCard(
                                    title: "Memento Mori",
                                    subtitle: "Daily reflection",
                                    icon: "hourglass",
                                    destination: Challenge1View()
                                )
                                
                                ChallengeCard(
                                    title: "Cold Shower",
                                    subtitle: "30 days challenge",
                                    icon: "drop.fill",
                                    destination: Challenge2View()
                                )
                            }
                            
                            // Segunda fila
                            HStack(spacing: 20) {
                                ChallengeCard(
                                    title: "No Complaints",
                                    subtitle: "Mindfulness",
                                    icon: "mouth",
                                    destination: Challenge3View()
                                )
                                
                                ChallengeCard(
                                    title: "Digital Fast",
                                    subtitle: "Focus training",
                                    icon: "iphone.slash",
                                    destination: Challenge4View()
                                )
                            }
                            
                            HStack(spacing: 20) {
                                ChallengeCard(
                                    title: "Early Wake",
                                    subtitle: "Discipline",
                                    icon: "sunrise.fill",
                                    destination: Challenge5View()
                                )
                                
                                ChallengeCard(
                                    title: "Journaling",
                                    subtitle: "Self-awareness",
                                    icon: "book.fill",
                                    destination: Challenge6View()
                                )
                            }
                            
                            HStack(spacing: 20) {
                                ChallengeCard(
                                    title: "Early Wake",
                                    subtitle: "Discipline",
                                    icon: "sunrise.fill",
                                    destination: Challenge7View()
                                )
                                
                                ChallengeCard(
                                    title: "Journaling",
                                    subtitle: "Self-awareness",
                                    icon: "book.fill",
                                    destination: Challenge8View()
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
//                        // Estadísticas o información adicional
//                        VStack(spacing: 15) {
//                            Text("Your Progress")
//                                .font(.title2)
//                                .bold()
//                                .foregroundColor(.red)
//                            
//                            HStack(spacing: 30) {
//                                ProgressStat(
//                                    value: "3",
//                                    label: "Completed",
//                                    color: .green
//                                )
//                                
//                                ProgressStat(
//                                    value: "2",
//                                    label: "In Progress",
//                                    color: .yellow
//                                )
//                                
//                                ProgressStat(
//                                    value: "5",
//                                    label: "Available",
//                                    color: .blue
//                                )
//                            }
//                        }
//                        .padding(.top, 20)
//                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Componente para tarjetas de desafío
struct ChallengeCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                // Fondo con efecto
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.8),
                                Color.purple.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 12) {
                    // Icono
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                        )
                    
                    // Texto
                    VStack(spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.vertical, 15)
            }
            .frame(width: 160, height: 160)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Componente para estadísticas
struct ProgressStat: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

// Vistas de desafío mejoradas
struct Challenge1View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text("Memento Mori")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality")
                        Text("• Reflect on what truly matters in your life")
                        Text("• Appreciate one thing you often take for granted")
                        Text("• Set an intention for the day")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

// Challenge2View, Challenge3View, etc. similares pero con diferentes colores

struct Challenge2View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text("Digital fast")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality")
                        Text("• Reflect on what truly matters in your life")
                        Text("• Appreciate one thing you often take for granted")
                        Text("• Set an intention for the day")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

struct Challenge3View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text("Digital fast")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality")
                        Text("• Reflect on what truly matters in your life")
                        Text("• Appreciate one thing you often take for granted")
                        Text("• Set an intention for the day")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

struct Challenge4View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text("Digital fast")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality")
                        Text("• Reflect on what truly matters in your life")
                        Text("• Appreciate one thing you often take for granted")
                        Text("• Set an intention for the day")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

struct Challenge5View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text("Digital fast")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality")
                        Text("• Reflect on what truly matters in your life")
                        Text("• Appreciate one thing you often take for granted")
                        Text("• Set an intention for the day")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

struct Challenge6View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text("Digital fast")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality")
                        Text("• Reflect on what truly matters in your life")
                        Text("• Appreciate one thing you often take for granted")
                        Text("• Set an intention for the day")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}



struct Challenge7View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text("Memento Mori")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality")
                        Text("• Reflect on what truly matters in your life")
                        Text("• Appreciate one thing you often take for granted")
                        Text("• Set an intention for the day")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}


struct Challenge8View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text("Memento Mori")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality")
                        Text("• Reflect on what truly matters in your life")
                        Text("• Appreciate one thing you often take for granted")
                        Text("• Set an intention for the day")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}
#Preview {
    ChallengesView()
}
