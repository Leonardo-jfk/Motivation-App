//
//  ChallengesView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 05/01/2026.
//

import Foundation
import SwiftUI
import Lottie
import Combine




// Modelo para el progreso del usuario
struct ChallengeProgress: Identifiable, Codable {
    let id: UUID
    let challengeId: String
    var isCompleted: Bool
    var isStarted: Bool
    var startDate: Date?
    var completionDate: Date?
    var progressPercentage: Double
    var currentStreak: Int
    var bestStreak: Int
    var totalDays: Int
    var completedDays: Int
    
    init(challengeId: String) {
        self.id = UUID()
        self.challengeId = challengeId
        self.isCompleted = false
        self.isStarted = false
        self.progressPercentage = 0
        self.currentStreak = 0
        self.bestStreak = 0
        self.totalDays = 0
        self.completedDays = 0
    }
    
    mutating func startChallenge(totalDays: Int = 30) {
        self.isStarted = true
        self.startDate = Date()
        self.totalDays = totalDays
    }
    
    mutating func markDayCompleted() {
        guard isStarted && !isCompleted else { return }
        
        completedDays += 1
        currentStreak += 1
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
        
        progressPercentage = Double(completedDays) / Double(totalDays)
        
        if completedDays >= totalDays {
            completeChallenge()
        }
    }
    
    mutating func missDay() {
        currentStreak = 0
    }
    
    mutating func completeChallenge() {
        isCompleted = true
        completionDate = Date()
        progressPercentage = 1.0
    }
    
    mutating func resetChallenge() {
        isCompleted = false
        isStarted = false
        startDate = nil
        completionDate = nil
        progressPercentage = 0
        currentStreak = 0
        totalDays = 0
        completedDays = 0
    }
}

// Gestor de progreso
class ChallengeProgressManager: ObservableObject {
    @Published var challengesProgress: [String: ChallengeProgress] = [:]
    
    private let challenges = [
        "challenge1": "Memento Mori",
        "challenge2": "Digital fast",
        "challenge3": "No Complaints",
        "challenge4": "Cold Exposure",
        "challenge5": "Early Wake",
        "challenge6": "Journaling",
        "challenge7": "Consumption",
        "challenge8": "Gratification"
    ]
    
    init() {
        loadProgress()
        initializeMissingChallenges()
    }
    
    private func initializeMissingChallenges() {
        for (id, _) in challenges {
            if challengesProgress[id] == nil {
                challengesProgress[id] = ChallengeProgress(challengeId: id)
            }
        }
        saveProgress()
    }
    
    // Funciones para manejar el progreso
    func startChallenge(_ challengeId: String, totalDays: Int = 30) {
        if var progress = challengesProgress[challengeId] {
            progress.startChallenge(totalDays: totalDays)
            challengesProgress[challengeId] = progress
            saveProgress()
        }
    }
    
    func markDayCompleted(_ challengeId: String) {
        if var progress = challengesProgress[challengeId] {
            progress.markDayCompleted()
            challengesProgress[challengeId] = progress
            saveProgress()
        }
    }
    
    func markChallengeCompleted(_ challengeId: String) {
        if var progress = challengesProgress[challengeId] {
            progress.completeChallenge()
            challengesProgress[challengeId] = progress
            saveProgress()
        }
    }
    
    func resetChallenge(_ challengeId: String) {
        if var progress = challengesProgress[challengeId] {
            progress.resetChallenge()
            challengesProgress[challengeId] = progress
            saveProgress()
        }
    }
    
    func getProgress(_ challengeId: String) -> ChallengeProgress? {
        return challengesProgress[challengeId]
    }
    
    // Funciones para estadísticas
    func getCompletedCount() -> Int {
        return challengesProgress.values.filter { $0.isCompleted }.count
    }
    
    func getInProgressCount() -> Int {
        return challengesProgress.values.filter { $0.isStarted && !$0.isCompleted }.count
    }
    
    func getAvailableCount() -> Int {
        return challengesProgress.values.filter { !$0.isStarted && !$0.isCompleted }.count
    }
    
    func getTotalProgressPercentage() -> Double {
        let totalChallenges = challengesProgress.count
        guard totalChallenges > 0 else { return 0 }
        
        let totalPercentage = challengesProgress.values.reduce(0) { $0 + $1.progressPercentage }
        return totalPercentage / Double(totalChallenges)
    }
    
    // Persistencia
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(challengesProgress) {
            UserDefaults.standard.set(encoded, forKey: "challengesProgress")
        }
    }
    
    private func loadProgress() {
        if let savedData = UserDefaults.standard.data(forKey: "challengesProgress"),
           let decoded = try? JSONDecoder().decode([String: ChallengeProgress].self, from: savedData) {
            challengesProgress = decoded
        }
    }
}







public struct ChallengesView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    private var appScheme: AppColorScheme {
        AppColorScheme(rawValue: storedScheme) ?? .system
    }
    
    @State private var navigationPath = NavigationPath()
    @StateObject private var progressManager = ChallengeProgressManager()

    
   public var body: some View {
        let backImage = (colorScheme == .dark) ? "BackDarkMarco" : "BackLightMarco"
        
        NavigationStack {
            ZStack(alignment: .center) {
                // Fondo
                Image(backImage)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Contenido principal
                ScrollView {
                    VStack(alignment: .center, spacing: 30) {
                        // Header
                        VStack(spacing: 15) {
                            Text("Challenges List".localized)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                                .shadow(radius: 3)
                            
                            // Estadísticas o información adicional
                            VStack(spacing: 15) {
                                Text("Your Progress".localized)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .opacity(0.7)
                                
//                                HStack(spacing: 30) {
                                //                                    ProgressStat(
                                //                                        value: "3",
                                //                                        label: "Completed".localized,
                                //                                        color: .green
                                //                                    )
                                //
                                //                                    ProgressStat(
                                //                                        value: "2",
                                //                                        label: "In Progress".localized,
                                //                                        color: .yellow
                                //                                    )
                                //
                                //                                    ProgressStat(
                                //                                        value: "5",
                                //                                        label: "Available".localized,
                                //                                        color: .blue
                                //                                    )
                                //                                }
                                
                                HStack(spacing: 30) {
                                    ProgressStat(
                                        value: "\(progressManager.getCompletedCount())",
                                        label: "Completed".localized,
                                        opacity: 0.4 // Menos opacidad para Completed
                                    )
                                    
                                    ProgressStat(
                                        value: "\(progressManager.getInProgressCount())",
                                        label: "In Progress".localized,
                                        opacity: 0.6 // Opacidad media para In Progress
                                    )
                                    
                                    ProgressStat(
                                        value: "\(progressManager.getAvailableCount())",
                                        label: "Available".localized,
                                        opacity: 0.8 // Mayor opacidad para Available
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
                                    subtitle: "Daily reflection".localized,
                                    icon: "hourglass",
                                    progress: progressManager.getProgress("challenge1"),
                                    destination: Challenge1View()
                                )
                                
                                ChallengeCard(
                                    title: "Digital fast".localized,
                                    subtitle: "Get back the focus".localized,
                                    icon: "iphone.slash",
                                    progress: progressManager.getProgress("challenge1"),
                                    destination: Challenge2View()
                                    
                                )
                            }
                            
                            // Segunda fila
                            HStack(spacing: 20) {
                                ChallengeCard(
                                    title: "No Complaints".localized,
                                    subtitle: "Mindfulness".localized,
                                    icon: "mouth",
                                    progress: progressManager.getProgress("challenge1"),
                                    destination: Challenge3View()
                                )
                                
                                ChallengeCard(
                                    title: "Cold Exposure".localized,
                                    subtitle: "30 days challenge".localized,
                                    icon: "drop.fill",
                                    progress: progressManager.getProgress("challenge1"),
                                    destination: Challenge4View()
                                )
                            }
                            
                            HStack(spacing: 20) {
                                ChallengeCard(
                                    title: "Early Wake".localized,
                                    subtitle: "Discipline".localized,
                                    icon: "sunrise.fill",
                                    progress: progressManager.getProgress("challenge1"),
                                    destination: Challenge5View()
                                )
                                
                                ChallengeCard(
                                    title: "Journaling".localized,
                                    subtitle: "Self-awareness".localized,
                                    icon: "book.fill",
                                    progress: progressManager.getProgress("challenge1"),
                                    destination: Challenge6View()
                                )
                            }
                            
                            HStack(spacing: 20) {
                                ChallengeCard(
                                    title: "Consumption".localized,
                                    subtitle: "Question your desire".localized,
                                    icon: "sterlingsign.ring.dashed",
                                    progress: progressManager.getProgress("challenge1"),
                                    destination: Challenge7View()
                                )
                                
                                ChallengeCard(
                                    title: "Gratification".localized,
                                    subtitle: "Do what matters".localized,
                                    icon: "figure.mind.and.body",
                                    progress: progressManager.getProgress("challenge1"),
                                    destination: Challenge8View()
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
//            .navigationBarHidden(true)
        }
    }
}

// Componente para tarjetas de desafío
//struct ChallengeCard<Destination: View>: View {
//    let title: String
//    let subtitle: String
//    let icon: String
//    let destination: Destination
//    
//    var body: some View {
//        NavigationLink(destination: destination) {
//            ZStack {
//                // Fondo con efecto
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(
//                        LinearGradient(
//                            gradient: Gradient(colors: [
//                                Color.blue.opacity(0.8),
//                                Color.purple.opacity(0.6)
//                            ]),
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                    )
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                    )
//                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
//                
//                VStack(spacing: 12) {
//                    // Icono
//                    Image(systemName: icon)
//                        .font(.system(size: 30))
//                        .foregroundColor(.white)
//                        .frame(width: 60, height: 60)
//                        .background(
//                            Circle()
//                                .fill(Color.white.opacity(0.2))
//                        )
//                    
//                    // Texto
//                    VStack(spacing: 4) {
//                        Text(title)
//                            .font(.headline)
//                            .bold()
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.center)
//                            .lineLimit(1)
//                            .minimumScaleFactor(0.8)
//                        
//                        Text(subtitle)
//                            .font(.caption)
//                            .foregroundColor(.white.opacity(0.8))
//                            .multilineTextAlignment(.center)
//                            .lineLimit(2)
//                    }
//                    .padding(.horizontal, 8)
//                }
//                .padding(.vertical, 15)
//            }
//            .frame(width: 160, height: 160)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}



struct ChallengeCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let progress: ChallengeProgress?
    let destination: Destination
    
    private var circleOpacity: Double {
        guard let progress = progress else { return 0.8 }
        
        if progress.isCompleted {
            return 0.9 // Casi sólido para completado
        } else if progress.isStarted {
            return 0.6 // Medio para en progreso
        } else {
            return 0.4 // Más transparente para disponible
        }
    }
    
    private var circleColor: Color {
        guard let progress = progress else { return .white }
        
        if progress.isCompleted {
            return .gray
        } else if progress.isStarted {
            return .gray
        } else {
            return .gray
        }
    }
    
    private var progressText: String {
        guard let progress = progress else { return "" }
        
        if progress.isCompleted {
            return "✓"
        } else if progress.isStarted {
            return "\(Int(progress.progressPercentage * 100))%"
        } else {
            return ""
        }
    }
    
    private var borderColor: Color {
        guard let progress = progress else { return .clear }
        
        if progress.isCompleted {
            return .gray.opacity(0.8)
        } else if progress.isStarted {
            return .gray.opacity(0.5)
        } else {
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        guard let progress = progress else { return 0 }
        
        if progress.isCompleted {
            return 2
        } else if progress.isStarted {
            return 1
        } else {
            return 0
        }
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                // Fondo en escala de grises
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.7),
                                Color.gray.opacity(0.5)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 12) {
                    // Indicador de progreso
                    if !progressText.isEmpty {
                        ZStack {
                            Circle()
                                .fill(circleColor.opacity(circleOpacity))
                                .frame(width: 30, height: 30)
                            
                            Text(progressText)
                                .font(.caption)
                                .bold()
                                .foregroundColor(.black)
                        }
                        .offset(x: 60, y: -60)
                    }
                    
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
//struct ProgressStat: View {
//    let value: String
//    let label: String
//    let color: Color
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            Text(value)
//                .font(.system(size: 28, weight: .bold))
//                .foregroundColor(color)
//            
//            Text(label)
//                .font(.caption)
//                .foregroundColor(.gray.opacity(0.8))
//                .multilineTextAlignment(.center)
//        }
//        .frame(width: 80)
//    }
//}


// Componente para estadísticas
struct ProgressStat: View {
    let value: String
    let label: String
    let opacity: Double // 0.8 para Available, menos para otros
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    private var appScheme: AppColorScheme {
        AppColorScheme(rawValue: storedScheme) ?? .system
    }
    
    
    var body: some View {
        VStack(spacing: 8) {
            // Círculo con número
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(opacity))
                    .frame(width: 72, height: 72)
                VStack{
                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(label)
                        .font(.caption)
                    //                .foregroundColor(.black.opacity(0.7))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .opacity(0.9)
                        .multilineTextAlignment(.center)
                }
            }
            
//            Text(label)
//                .font(.caption)
////                .foregroundColor(.black.opacity(0.7))
//                .foregroundColor(colorScheme == .dark ? .white : .black)
//                .opacity(0.9)
//                .multilineTextAlignment(.center)
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
                gradient: Gradient(colors: [Color.black, Color.gray]),
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
                        Text("Challenge Description".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.".localized)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Write for 5 minutes each morning about your mortality".localized)
                        Text("• Reflect on what truly matters in your life".localized)
                        Text("• Appreciate one thing you often take for granted".localized)
                        Text("• Set an intention for the day".localized)
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
                        Text("Start Challenge".localized)
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
                        Text("Mark as Completed".localized)
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
                gradient: Gradient(colors: [Color.black, Color.gray]),
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
                    Text("Digital fast".localized)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "iphone.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Reclaim your attention from digital distractions. Break addictive screen habits to cultivate presence, focus, and authentic connection in the physical world.".localized)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• First 60 minutes after waking: No screens".localized)
                        Text("• Designate 3 screen-free hours daily".localized)
                        Text("• Turn off all non-essential notifications".localized)
                        Text("• No devices during meals or conversations".localized)
                        Text("• Digital sunset 2 hours before bed".localized)
                        
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
                        Text("Start Challenge".localized)
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
                        Text("Mark as Completed".localized)
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
                gradient: Gradient(colors: [Color.black, Color.gray]),
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
                    Text("No Complaints".localized)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "person.spatialaudio.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Replace complaining with constructive action. Train yourself to notice negative speech patterns and transform them into solution-oriented thinking.".localized)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Wear a bracelet/reminder (switch wrists when complaining)".localized)
                        Text("• Practice 10-second pause before speaking".localized)
                        Text("• Find one solution for every complaint voiced".localized)
                        Text("• Reframe obstacles as opportunities".localized)
                        Text("• Practice Stoic acceptance of things outside control".localized)
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
                        Text("Start Challenge".localized)
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
                        Text("Mark as Completed".localized)
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
                gradient: Gradient(colors: [Color.black, Color.gray]),
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
                    Text("Cold Exposure".localized)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "thermometer.snowflake")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Build mental toughness through voluntary discomfort. Wear sweaters indoors, acclimate gradually, and build resilience through daily comfort reduction.".localized)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• 1-minute cold shower finish".localized)
                        Text("• Full cold shower".localized)
                        Text("• Open windows at night".localized)
                        Text("• Reduce heating your home".localized)
                        Text("• Wear appropriate wool/sweaters instead of heating".localized)
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
                        Text("Start Challenge".localized)
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
                        Text("Mark as Completed".localized)
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
                gradient: Gradient(colors: [Color.black, Color.gray]),
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
                    Text("Early Wake".localized)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "sun.haze")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Reclaim the quiet hours before the world wakes. Build discipline through consistent early rising, creating space for intentional living before daily demands consume your attention and energy.".localized)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Wake 30 minutes earlier".localized)
                        Text("• Drink large glass of water".localized)
                        Text("• One simple productive task".localized)
                        Text("• Plan day's top 3 priorities".localized)
                        Text("• Creative time with no interruptions (write, draw, create)".localized)
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
                        Text("Start Challenge".localized)
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
                        Text("Mark as Completed".localized)
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
                gradient: Gradient(colors: [Color.black, Color.gray]),
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
                    Text("Journaling".localized)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "highlighter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Transform random thoughts into structured wisdom through daily Stoic journaling. Move from mental clutter to philosophical clarity by systematically examining your day through the lens of Stoic principles.".localized)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• 10 minutes before bed: Review your day".localized)
                        Text("• What went well? (3 things)".localized)
                        Text("• Write a conversation with a Stoic philosopher".localized)
                        Text("• Never take advice from someone who you wouldn’t trade your life with".localized)
                        Text("• Establish some definite discipline and rules for yourself".localized)
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
                        Text("Start Challenge".localized)
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
                        Text("Mark as Completed".localized)
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
                gradient: Gradient(colors: [Color.black, Color.gray]),
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
                    Text("Conscious Consumption".localized)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "shekelsign.arrow.trianglehead.counterclockwise.rotate.90")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Question every desire before acting on it. Practice the Stoic pause between impulse and action to cultivate wisdom in consumption.".localized)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Wait 24 hours before any non-essential purchase".localized)
                        Text("• Ask: 'Is this a want or a need?' ".localized)
                        Text("• Track all spending consciously".localized)
                        Text("• One day per week: No spending".localized)
                        Text("• Donate one item for every new item".localized)
                        
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
                        Text("Start Challenge".localized)
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
                        Text("Mark as Completed".localized)
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
                gradient: Gradient(colors: [Color.black, Color.gray]),
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
                
                // Contenid"Delayed Gratification Mastery"o
                VStack(spacing: 25) {
                    Text("Delayed Gratification Mastery".localized)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "apple.meditate")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Master the art of waiting. Train yourself to value future abundance over immediate pleasure to build profound patience and long-term thinking.".localized)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task".localized)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• Save first, buy later".localized)
                        Text("• What you plant today, others/God/future-you will enjoy".localized)
                        Text("• Create '3-Year Waiting List' for desired items".localized)
                        Text("• Fix something broken instead of buying new".localized)
                        Text("• For each resisted purchase, transfer amount to savings".localized)
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
                        Text("Start Challenge".localized)
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
                        Text("Mark as Completed".localized)
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
