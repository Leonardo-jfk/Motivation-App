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

//
//
//
//// Modelo para el progreso del usuario
//struct ChallengeProgress: Identifiable, Codable {
//    let id: UUID
//    let challengeId: String
//    var isCompleted: Bool
//    var isStarted: Bool
//    var startDate: Date?
//    var completionDate: Date?
//    var progressPercentage: Double
//    var currentStreak: Int
//    var bestStreak: Int
//    var totalDays: Int
//    var completedDays: Int
//    
//    init(challengeId: String) {
//        self.id = UUID()
//        self.challengeId = challengeId
//        self.isCompleted = false
//        self.isStarted = false
//        self.progressPercentage = 0
//        self.currentStreak = 0
//        self.bestStreak = 0
//        self.totalDays = 0
//        self.completedDays = 0
//    }
//    
//    mutating func startChallenge(totalDays: Int = 30) {
//        self.isStarted = true
//        self.startDate = Date()
//        self.totalDays = totalDays
//    }
//    
//    mutating func markDayCompleted() {
//        guard isStarted && !isCompleted else { return }
//        
//        completedDays += 1
//        currentStreak += 1
//        if currentStreak > bestStreak {
//            bestStreak = currentStreak
//        }
//        
//        progressPercentage = Double(completedDays) / Double(totalDays)
//        
//        if completedDays >= totalDays {
//            completeChallenge()
//        }
//    }
//    
//    mutating func missDay() {
//        currentStreak = 0
//    }
//    
//    mutating func completeChallenge() {
//        isCompleted = true
//        completionDate = Date()
//        progressPercentage = 1.0
//    }
//    
//    mutating func resetChallenge() {
//        isCompleted = false
//        isStarted = false
//        startDate = nil
//        completionDate = nil
//        progressPercentage = 0
//        currentStreak = 0
//        totalDays = 0
//        completedDays = 0
//    }
//}
//
//// Gestor de progreso
//class ChallengeProgressManager: ObservableObject {
//    @Published var challengesProgress: [String: ChallengeProgress] = [:]
//    
//    private let challenges = [
//        "challenge1": "Memento Mori",
//        "challenge2": "Digital fast",
//        "challenge3": "No Complaints",
//        "challenge4": "Cold Exposure",
//        "challenge5": "Early Wake",
//        "challenge6": "Journaling",
//        "challenge7": "Consumption",
//        "challenge8": "Gratification"
//    ]
//    
//    init() {
//        loadProgress()
//        initializeMissingChallenges()
//    }
//    
//    private func initializeMissingChallenges() {
//        for (id, _) in challenges {
//            if challengesProgress[id] == nil {
//                challengesProgress[id] = ChallengeProgress(challengeId: id)
//            }
//        }
//        saveProgress()
//    }
//    
//    // Funciones para manejar el progreso
//    func startChallenge(_ challengeId: String, totalDays: Int = 30) {
//        if var progress = challengesProgress[challengeId] {
//            progress.startChallenge(totalDays: totalDays)
//            challengesProgress[challengeId] = progress
//            saveProgress()
//        }
//    }
//    
//    func markDayCompleted(_ challengeId: String) {
//        if var progress = challengesProgress[challengeId] {
//            progress.markDayCompleted()
//            challengesProgress[challengeId] = progress
//            saveProgress()
//        }
//    }
//    
//    func markChallengeCompleted(_ challengeId: String) {
//        if var progress = challengesProgress[challengeId] {
//            progress.completeChallenge()
//            challengesProgress[challengeId] = progress
//            saveProgress()
//        }
//    }
//    
//    func resetChallenge(_ challengeId: String) {
//        if var progress = challengesProgress[challengeId] {
//            progress.resetChallenge()
//            challengesProgress[challengeId] = progress
//            saveProgress()
//        }
//    }
//    
//    func getProgress(_ challengeId: String) -> ChallengeProgress? {
//        return challengesProgress[challengeId]
//    }
//    
//    // Funciones para estadísticas
//    func getCompletedCount() -> Int {
//        return challengesProgress.values.filter { $0.isCompleted }.count
//    }
//    
//    func getInProgressCount() -> Int {
//        return challengesProgress.values.filter { $0.isStarted && !$0.isCompleted }.count
//    }
//    
//    func getAvailableCount() -> Int {
//        return challengesProgress.values.filter { !$0.isStarted && !$0.isCompleted }.count
//    }
//    
//    func getTotalProgressPercentage() -> Double {
//        let totalChallenges = challengesProgress.count
//        guard totalChallenges > 0 else { return 0 }
//        
//        let totalPercentage = challengesProgress.values.reduce(0) { $0 + $1.progressPercentage }
//        return totalPercentage / Double(totalChallenges)
//    }
//    
//    // Persistencia
//    private func saveProgress() {
//        if let encoded = try? JSONEncoder().encode(challengesProgress) {
//            UserDefaults.standard.set(encoded, forKey: "challengesProgress")
//        }
//    }
//    
//    private func loadProgress() {
//        if let savedData = UserDefaults.standard.data(forKey: "challengesProgress"),
//           let decoded = try? JSONDecoder().decode([String: ChallengeProgress].self, from: savedData) {
//            challengesProgress = decoded
//        }
//    }
//}
//
//
//
//
//
//
//
//public struct ChallengesView: View {
//    
//    @Environment(\.colorScheme) var colorScheme
//    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
//    private var appScheme: AppColorScheme {
//        AppColorScheme(rawValue: storedScheme) ?? .system
//    }
//    
//    @State private var navigationPath = NavigationPath()
//    @StateObject private var progressManager = ChallengeProgressManager()
//    
//    
//    // Funciones helper
//    private func getSubtitle(for challengeId: String) -> String {
//        switch challengeId {
//        case "challenge1": return "Daily reflection".localized
//        case "challenge2": return "Get back the focus".localized
//        case "challenge3": return "Mindfulness".localized
//        case "challenge4": return "30 days challenge".localized
//        case "challenge5": return "Discipline".localized
//        case "challenge6": return "Self-awareness".localized
//        case "challenge7": return "Question your desire".localized
//        case "challenge8": return "Do what matters".localized
//        default: return ""
//        }
//    }
//
//    private func getDestinationView(for index: Int) -> some View {
//        switch index {
//        case 0: return AnyView(Challenge1View(progressManager: progressManager))
//        case 1: return AnyView(Challenge2View(progressManager: progressManager))
//        case 2: return AnyView(Challenge3View(progressManager: progressManager))
//        case 3: return AnyView(Challenge4View(progressManager: progressManager))
//        case 4: return AnyView(Challenge5View(progressManager: progressManager))
//        case 5: return AnyView(Challenge6View(progressManager: progressManager))
//        case 6: return AnyView(Challenge7View(progressManager: progressManager))
//        case 7: return AnyView(Challenge8View(progressManager: progressManager))
//        default: return AnyView(EmptyView())
//        }
//    }
//    
//   public var body: some View {
//        let backImage = (colorScheme == .dark) ? "BackDarkMarco" : "BackLightMarco"
//        
//        NavigationStack {
//            ZStack(alignment: .center) {
//                // Fondo
//                Image(backImage)
//                    .resizable()
//                    .scaledToFit()
//                    .ignoresSafeArea()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                
//                // Contenido principal
//                ScrollView {
//                    VStack(alignment: .center, spacing: 30) {
//                        // Header
//                        VStack(spacing: 15) {
//                            Text("Challenges List".localized)
//                                .font(.system(size: 36, weight: .bold))
//                                .foregroundColor(.white)
//                                .shadow(radius: 10)
//                                .shadow(radius: 3)
//                            
//                            // Estadísticas o información adicional
//                            VStack(spacing: 15) {
//                                Text("Your Progress".localized)
//                                    .font(.title2)
//                                    .bold()
//                                    .foregroundColor(colorScheme == .dark ? .white : .black)
//                                    .opacity(0.7)
//                                
//                                HStack(spacing: 30) {
//                                    ProgressStat(
//                                        value: "\(progressManager.getCompletedCount())",
//                                        label: "Completed".localized,
//                                        opacity: 0.4 // Menos opacidad para Completed
//                                    )
//                                    
//                                    ProgressStat(
//                                        value: "\(progressManager.getInProgressCount())",
//                                        label: "In Progress".localized,
//                                        opacity: 0.6 // Opacidad media para In Progress
//                                    )
//                                    
//                                    ProgressStat(
//                                        value: "\(progressManager.getAvailableCount())",
//                                        label: "Available".localized,
//                                        opacity: 0.8 // Mayor opacidad para Available
//                                    )
//                                }
//                                
//                                
//                                
//                            }
//                            .padding(.top, 20)
//                            .padding(.bottom, 40)
//                        }
//                        .padding(.top, 40)
//                        
//                        // Grid de desafíos
//                        VStack(spacing: 20) {
//                            // Primera fila
//                            HStack(spacing: 20) {
//                                ChallengeCard(
//                                    title: "Memento Mori",
//                                    subtitle: "Daily reflection".localized,
//                                    icon: "hourglass",
//                                    progress: progressManager.getProgress("challenge1"),
//                                    destination: Challenge1View(progressManager: progressManager)
//                                )
//                                
//                                ChallengeCard(
//                                    title: "Digital fast".localized,
//                                    subtitle: "Get back the focus".localized,
//                                    icon: "iphone.slash",
//                                    progress: progressManager.getProgress("challenge2"),
//                                    destination: Challenge2View(progressManager: progressManager)
//                                    
//                                )
//                            }
//                            
//                            // Segunda fila
//                            HStack(spacing: 20) {
//                                ChallengeCard(
//                                    title: "No Complaints".localized,
//                                    subtitle: "Mindfulness".localized,
//                                    icon: "mouth",
//                                    progress: progressManager.getProgress("challenge3"),
//                                    destination: Challenge3View(progressManager: progressManager)
//                                )
//                                
//                                ChallengeCard(
//                                    title: "Cold Exposure".localized,
//                                    subtitle: "30 days challenge".localized,
//                                    icon: "drop.fill",
//                                    progress: progressManager.getProgress("challenge4"),
//                                    destination: Challenge4View(progressManager: progressManager)
//                                )
//                            }
//                            
//                            HStack(spacing: 20) {
//                                ChallengeCard(
//                                    title: "Early Wake".localized,
//                                    subtitle: "Discipline".localized,
//                                    icon: "sunrise.fill",
//                                    progress: progressManager.getProgress("challenge5"),
//                                    destination: Challenge5View(progressManager: progressManager)
//                                )
//                                
//                                ChallengeCard(
//                                    title: "Journaling".localized,
//                                    subtitle: "Self-awareness".localized,
//                                    icon: "book.fill",
//                                    progress: progressManager.getProgress("challenge6"),
//                                    destination: Challenge6View(progressManager: progressManager)
//                                )
//                            }
//                            
//                            HStack(spacing: 20) {
//                                ChallengeCard(
//                                    title: "Consumption".localized,
//                                    subtitle: "Question your desire".localized,
//                                    icon: "sterlingsign.ring.dashed",
//                                    progress: progressManager.getProgress("challenge7"),
//                                    destination: Challenge7View(progressManager: progressManager)
//                                )
//                                
//                                ChallengeCard(
//                                    title: "Gratification".localized,
//                                    subtitle: "Do what matters".localized,
//                                    icon: "figure.mind.and.body",
//                                    progress: progressManager.getProgress("challenge8"),
//                                    destination: Challenge8View(progressManager: progressManager)
//                                )
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.bottom, 100)
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//            }
////            .navigationBarHidden(true)
//        }
//    }
//}
//
//
struct ChallengeCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let progress: ChallengeProgress? // Mantenemos esto como let
    let destination: Destination
    
    // Cambia las propiedades computadas a @State o usa @State para evitar mutación concurrente
    @State private var circleOpacity: Double = 0.8
//    @State private var progressText: String = ""
    @State private var borderColor: Color = .clear
    @State private var borderWidth: CGFloat = 0
    
    init(title: String, subtitle: String, icon: String, progress: ChallengeProgress?, destination: Destination) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.progress = progress
        self.destination = destination
        
        // Inicializamos los valores en el init
        _borderColor = State(initialValue: Self.calculateBorderColor(progress: progress))
        _borderWidth = State(initialValue: Self.calculateBorderWidth(progress: progress))
    }
    
    // Métodos estáticos para calcular los valores
    private static func calculateBorderColor(progress: ChallengeProgress?) -> Color {
        guard let progress = progress else { return .clear }
        
        if progress.isCompleted {
            return .gray.opacity(0.8)
        } else if progress.isStarted {
            return .gray.opacity(0.5)
        } else {
            return .clear
        }
    }
    
    private static func calculateBorderWidth(progress: ChallengeProgress?) -> CGFloat {
        guard let progress = progress else { return 0 }
        
        if progress.isCompleted {
            return 5
        } else if progress.isStarted {
            return 2
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






//// Componente para estadísticas
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
            
        }
        .frame(width: 80)
    }
}
//
//
//
//
//
//
////Text("• \(task.localized)")
//
//struct ChallengeData {
//    let id: String
//    let title: String
//    let icon: String
//    let description: String
//    let tasks: [String]
//    
//    static let allChallenges: [ChallengeData] = [
//        ChallengeData(
//            id: "challenge1",
//            title: "Memento Mori",
//            icon: "hourglass",
//            description: "Practice daily reflection on mortality to appreciate the present moment and live intentionally.",
//            tasks: [
//                "Write for 5 minutes each morning about your mortality",
//                "Reflect on what truly matters in your life",
//                "Appreciate one thing you often take for granted",
//                "Set an intention for the day"
//            ]
//        ),
//        ChallengeData(
//            id: "challenge2",
//            title: "Digital fast".localized,
//            icon: "iphone.slash",
//            description: "Reclaim your attention from digital distractions. Break addictive screen habits to cultivate presence, focus, and authentic connection in the physical world.",
//            tasks: [
//                "First 60 minutes after waking: No screens",
//                "Designate 3 screen-free hours daily",
//                "Turn off all non-essential notifications",
//                "No devices during meals or conversations",
//                "Digital sunset 2 hours before bed"
//            ]
//        ),
//        ChallengeData(
//            id: "challenge3",
//            title: "No Complaints".localized,
//            icon: "person.spatialaudio.fill",
//            description: "Replace complaining with constructive action. Train yourself to notice negative speech patterns and transform them into solution-oriented thinking.",
//            tasks: [
//                "Wear a bracelet/reminder (switch wrists when complaining)",
//                "Practice 10-second pause before speaking",
//                "Find one solution for every complaint voiced",
//                "Reframe obstacles as opportunities",
//                "Practice Stoic acceptance of things outside control"
//            ]
//        ),
//        ChallengeData(
//            id: "challenge4",
//            title: "Cold Exposure".localized,
//            icon: "thermometer.snowflake",
//            description: "Build mental toughness through voluntary discomfort. Wear sweaters indoors, acclimate gradually, and build resilience through daily comfort reduction.",
//            tasks: [
//                "1-minute cold shower finish",
//                "Full cold shower",
//                "Open windows at night",
//                "Reduce heating your home",
//                "Wear appropriate wool/sweaters instead of heating"
//            ]
//        ),
//        ChallengeData(
//            id: "challenge5",
//            title: "Early Wake".localized,
//            icon: "sun.haze",
//            description: "Reclaim the quiet hours before the world wakes. Build discipline through consistent early rising, creating space for intentional living before daily demands consume your attention and energy.",
//            tasks: [
//                "Wake 30 minutes earlier",
//                "Drink large glass of water",
//                "One simple productive task",
//                "Plan day's top 3 priorities",
//                "Creative time with no interruptions (write, draw, create)"
//            ]
//        ),
//        ChallengeData(
//            id: "challenge6",
//            title: "Journaling".localized,
//            icon: "book.fill",
//            description: "Transform random thoughts into structured wisdom through daily Stoic journaling. Move from mental clutter to philosophical clarity by systematically examining your day through the lens of Stoic principles.",
//            tasks: [
//                "10 minutes before bed: Review your day",
//                "What went well? (3 things)",
//                "Write a conversation with a Stoic philosopher",
//                "Never take advice from someone who you wouldn't trade your life with",
//                "Establish some definite discipline and rules for yourself"
//            ]
//        ),
//        ChallengeData(
//            id: "challenge7",
//            title: "Consumption".localized,
//            icon: "sterlingsign.ring.dashed",
//            description: "Question every desire before acting on it. Practice the Stoic pause between impulse and action to cultivate wisdom in consumption.",
//            tasks: [
//                "Wait 24 hours before any non-essential purchase",
//                "Ask: 'Is this a want or a need?'",
//                "Track all spending consciously",
//                "One day per week: No spending",
//                "Donate one item for every new item"
//            ]
//        ),
//        ChallengeData(
//            id: "challenge8",
//            title: "Gratification".localized,
//            icon: "figure.mind.and.body",
//            description: "Master the art of waiting. Train yourself to value future abundance over immediate pleasure to build profound patience and long-term thinking.",
//            tasks: [
//                "Save first, buy later",
//                "What you plant today, others/God/future-you will enjoy",
//                "Create '3-Year Waiting List' for desired items",
//                "Fix something broken instead of buying new",
//                "For each resisted purchase, transfer amount to savings"
//            ]
//        )
//    ]
//}
//
//
//
//
//
//struct ChallengeDetailView: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var progressManager: ChallengeProgressManager
//    
//    let challengeData: ChallengeData
//    
//    // ... resto del código igual ...
//    struct ChallengeDetailView: View {
//        @Environment(\.dismiss) var dismiss
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        let challengeData: ChallengeData
//        
//        // Calculamos las propiedades basándonos en el progreso actual
//        private var progress: ChallengeProgress? {
//            progressManager.getProgress(challengeData.id)
//        }
//        
//        @AppStorage("lastDatePracticed_\(challengeData.id)") private var lastDatePracticed: String = ""
//        
//        func canIncrementCounter() -> Bool {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let currentDateString = formatter.string(from: Date())
//            
//            return lastDatePracticed != currentDateString
//        }
//        
//        private func saveCurrentDate() {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let currentDateString = formatter.string(from: Date())
//            lastDatePracticed = currentDateString
//        }
//    
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Header
//                HStack {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // Contenido
//                VStack(spacing: 25) {
//                    // Título e icono
//                    if let progress = progress, !progress.isStarted {
//                        Text(challengeData.title.localized)
//                            .font(.system(size: 40, weight: .bold))
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.center)
//                        
//                        Image(systemName: challengeData.icon)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                            .foregroundColor(.white)
//                    } else {
//                        Text(challengeData.title.localized)
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.center)
//                        
//                        Image(systemName: challengeData.icon)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                            .foregroundColor(.white)
//                    }
//                    
//                    // Descripción y tareas
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text(challengeData.description.localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        ForEach(challengeData.tasks, id: \.self) { task in
//                            // Aquí añadimos el punto y .localized
//                            Text("• \(task.localized)")
//                                .foregroundColor(.white.opacity(0.9))
//                        }
//                    }
//                    .font(.body)
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                    
//                    // ... resto del código igual ...
//                }
//                
//                // ... resto del código igual ...
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//
//
//    struct ChallengeActionButtons: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        let challengeId: String
//        let progress: ChallengeProgress?
//        let canIncrement: Bool
//        let onIncrement: () -> Void
//        let onReset: () -> Void
//        
//        var body: some View {
//            VStack(spacing: 15) {
//                if let progress = progress {
//                    if progress.isCompleted {
//                        // Desafío completado
//                        Text("✓ Challenge Completed")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white.opacity(0.2))
//                            .cornerRadius(15)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 15)
//                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
//                            )
//                        
//                        Button(action: {
//                            progressManager.resetChallenge(challengeId)
//                            onReset()
//                        }) {
//                            Text("Restart Challenge".localized)
//                                .font(.subheadline)
//                                .foregroundColor(.white.opacity(0.8))
//                        }
//                        
//                    } else if progress.isStarted && !progress.isCompleted {
//                        // Desafío en progreso
//                        VStack(spacing: 15) {
//                            if canIncrement {
//                                Button(action: {
//                                    progressManager.markDayCompleted(challengeId)
//                                    onIncrement()
//                                }) {
//                                    Text("Mark Today as Completed".localized)
//                                        .font(.headline)
//                                        .foregroundColor(.white)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(Color.white.opacity(0.3))
//                                        .cornerRadius(15)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                        )
//                                }
//                            } else {
//                                Button(action: {}) {
//                                    Text("Completed Today ✓")
//                                        .font(.headline)
//                                        .foregroundColor(.white.opacity(0.6))
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(Color.white.opacity(0.1))
//                                        .cornerRadius(15)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                                        )
//                                }
//                                .disabled(true)
//                            }
//                            
//                            Button(action: {
//                                progressManager.markChallengeCompleted(challengeId)
//                            }) {
//                                Text("Complete Entire Challenge".localized)
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color.white.opacity(0.2))
//                                    .cornerRadius(15)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 15)
//                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                    )
//                            }
//                        }
//                        
//                    } else {
//                        // Desafío no empezado
//                        Button(action: {
//                            progressManager.startChallenge(challengeId, totalDays: 30)
//                        }) {
//                            Text("Start Challenge".localized)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white.opacity(0.2))
//                                .cornerRadius(15)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                )
//                        }
//                    }
//                } else {
//                    // Estado inicial
//                    Button(action: {
//                        progressManager.startChallenge(challengeId, totalDays: 30)
//                    }) {
//                        Text("Start Challenge".localized)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white.opacity(0.2))
//                            .cornerRadius(15)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 15)
//                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                            )
//                    }
//                }
//            }
//        }
//    }
//
//
//
//    struct Challenge1View: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        var body: some View {
//            ChallengeDetailView(
//                progressManager: progressManager,
//                challengeData: ChallengeData.allChallenges[0]
//            )
//        }
//    }
//
//    struct Challenge2View: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        var body: some View {
//            ChallengeDetailView(
//                progressManager: progressManager,
//                challengeData: ChallengeData.allChallenges[1]
//            )
//        }
//    }
//
//    struct Challenge3View: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        var body: some View {
//            ChallengeDetailView(
//                progressManager: progressManager,
//                challengeData: ChallengeData.allChallenges[2]
//            )
//        }
//    }
//
//    struct Challenge4View: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        var body: some View {
//            ChallengeDetailView(
//                progressManager: progressManager,
//                challengeData: ChallengeData.allChallenges[3]
//            )
//        }
//    }
//
//    struct Challenge5View: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        var body: some View {
//            ChallengeDetailView(
//                progressManager: progressManager,
//                challengeData: ChallengeData.allChallenges[4]
//            )
//        }
//    }
//
//    struct Challenge6View: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        var body: some View {
//            ChallengeDetailView(
//                progressManager: progressManager,
//                challengeData: ChallengeData.allChallenges[5]
//            )
//        }
//    }
//
//    struct Challenge7View: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        var body: some View {
//            ChallengeDetailView(
//                progressManager: progressManager,
//                challengeData: ChallengeData.allChallenges[6]
//            )
//        }
//    }
//
//    struct Challenge8View: View {
//        @ObservedObject var progressManager: ChallengeProgressManager
//        
//        var body: some View {
//            ChallengeDetailView(
//                progressManager: progressManager,
//                challengeData: ChallengeData.allChallenges[7]
//            )
//        }
//    }
//
//
//
//
//
//
//
//
//
//
//
//struct Challenge1View: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var progressManager: ChallengeProgressManager
//    
//    private let challengeId = "challenge1"
//    
//    // Calculamos las propiedades basándonos en el progreso actual
//    private var progress: ChallengeProgress? {
//        progressManager.getProgress(challengeId)
//    }
//    
//    private var circleOpacity: Double {
//        guard let progress = progress else { return 0.8 }
//        
//        if progress.isCompleted {
//            return 0.9 // Casi sólido para completado
//        } else if progress.isStarted {
//            return 0.6 // Medio para en progreso
//        } else {
//            return 0.4 // Más transparente para disponible
//        }
//    }
//    
//    private var circleColor: Color {
//        guard let progress = progress else { return .gray }
//        
//        if progress.isCompleted {
//            return .gray
//        } else if progress.isStarted {
//            return .gray
//        } else {
//            return .gray
//        }
//    }
//    
//    private var progressText: String {
//        guard let progress = progress else { return "" }
//        
//        if progress.isCompleted {
//            return "✓"
//        } else if progress.isStarted {
//            return "\(Int(progress.progressPercentage * 100))%"
//        } else {
//            return ""
//        }
//    }
//    
//    @AppStorage("lastDatePracticed_\("challenge1")") private var lastDatePracticed: String = ""
//    
//    func canIncrementCounter() -> Bool {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let currentDateString = formatter.string(from: Date())
//        
//        // Si la fecha guardada es distinta a la de hoy, puede sumar
//        return lastDatePracticed != currentDateString
//    }
//    
//    private func saveCurrentDate() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let currentDateString = formatter.string(from: Date())
//        lastDatePracticed = currentDateString
//    }
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Botón de regreso con círculo de progreso
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // Contenido
//                VStack(spacing: 25) {
//                    // Título e icono condicionales
//                    if let progress = progress, !progress.isStarted {
//                        Text("Memento Mori")
//                            .font(.system(size: 40, weight: .bold))
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.center)
//                        
//                        Image(systemName: "hourglass")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                            .foregroundColor(.white)
//                    } else {
//                        Text("Memento Mori")
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.center)
//                        
//                        Image(systemName: "hourglass")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                            .foregroundColor(.white)
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("Practice daily reflection on mortality to appreciate the present moment and live intentionally.".localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("• Write for 5 minutes each morning about your mortality".localized)
//                        Text("• Reflect on what truly matters in your life".localized)
//                        Text("• Appreciate one thing you often take for granted".localized)
//                        Text("• Set an intention for the day".localized)
//                    }
//                    .font(.body)
//                    .foregroundColor(.white.opacity(0.9))
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                    
//                    // Información de progreso adicional
//                    if let progress = progress, progress.isStarted && !progress.isCompleted {
//                        VStack(spacing: 10) {
//                            Text("Progress: \(Int(progress.progressPercentage * 100))%")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            
//                            Text("Current Streak: \(progress.currentStreak) days")
//                                .foregroundColor(.white.opacity(0.8))
//                            Text("Best Streak: \(progress.bestStreak) days")
//                                .foregroundColor(.white.opacity(0.8))
//                        }
//                        .padding()
//                        .background(Color.white.opacity(0.1))
//                        .cornerRadius(10)
//                    }
//                }
//                
////                Spacer()
//                
//                // Botones de acción condicionales
//                VStack(spacing: 15) {
//                    if let progress = progress {
//                        if progress.isCompleted {
//                            // Si ya está completado
//                            Text("✓ Challenge Completed")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white.opacity(0.2))
//                                .cornerRadius(15)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
//                                )
//                            
//                            Button(action: {
//                                progressManager.resetChallenge(challengeId)
//                                // También reseteamos la fecha guardada
//                                lastDatePracticed = ""
//                            }) {
//                                Text("Restart Challenge".localized)
//                                    .font(.subheadline)
//                                    .foregroundColor(.white.opacity(0.8))
//                            }
//                            
//                        } else if progress.isStarted && !progress.isCompleted {
//                            // Si ya empezó pero no completó
//                            VStack(spacing: 15) {
//                                if canIncrementCounter() {
//                                    Button(action: {
//                                        progressManager.markDayCompleted(challengeId)
//                                        saveCurrentDate() // Guarda la fecha actual
//                                    }) {
////                                        Text("• \("Mark Today as Completed".localized)")
//                                        Text("Mark Today as Completed".localized)
//                                            .font(.headline)
//                                            .foregroundColor(.white)
//                                            .padding()
//                                            .frame(maxWidth: .infinity)
//                                            .background(Color.white.opacity(0.3))
//                                            .cornerRadius(15)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 15)
//                                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                            )
//                                    }
//                                } else {
//                                    Button(action: {
//                                        dismiss()
//                                    }) {
//                                        Text("Completed Today ✓")
//                                            .font(.headline)
//                                            .foregroundColor(.white.opacity(0.6))
//                                            .padding()
//                                            .frame(maxWidth: .infinity)
//                                            .background(Color.white.opacity(0.1))
//                                            .cornerRadius(15)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 15)
//                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                                            )
//                                    }
//                                }
//                                
//                                Button(action: {
//                                    progressManager.markChallengeCompleted(challengeId)
//                                }) {
//                                    Text("Complete Entire Challenge".localized)
//                                        .font(.headline)
//                                        .foregroundColor(.white)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(Color.white.opacity(0.2))
//                                        .cornerRadius(15)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                        )
//                                }
//                            }
//                            
//                        } else {
//                            // Si no ha empezado
//                            Button(action: {
//                                progressManager.startChallenge(challengeId, totalDays: 30)
//                            }) {
//                                Text("Start Challenge".localized)
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color.white.opacity(0.2))
//                                    .cornerRadius(15)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 15)
//                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                    )
//                            }
//                        }
//                    } else {
//                        // Estado inicial (no hay progreso)
//                        Button(action: {
//                            progressManager.startChallenge(challengeId, totalDays: 30)
//                        }) {
//                            Text("Start Challenge".localized)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white.opacity(0.2))
//                                .cornerRadius(15)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                )
//                        }
//                    }
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 30)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//struct Challenge2View: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var progressManager: ChallengeProgressManager
//    
//    private let challengeId = "challenge2"
//    
//    // Calculamos las propiedades basándonos en el progreso actual
//    private var progress: ChallengeProgress? {
//        progressManager.getProgress(challengeId)
//    }
//    
//    private var circleOpacity: Double {
//        guard let progress = progress else { return 0.8 }
//        
//        if progress.isCompleted {
//            return 0.9 // Casi sólido para completado
//        } else if progress.isStarted {
//            return 0.6 // Medio para en progreso
//        } else {
//            return 0.4 // Más transparente para disponible
//        }
//    }
//    
//    private var circleColor: Color {
//        guard let progress = progress else { return .gray }
//        
//        if progress.isCompleted {
//            return .gray
//        } else if progress.isStarted {
//            return .gray
//        } else {
//            return .gray
//        }
//    }
//    
//    private var progressText: String {
//        guard let progress = progress else { return "" }
//        
//        if progress.isCompleted {
//            return "✓"
//        } else if progress.isStarted {
//            return "\(Int(progress.progressPercentage * 100))%"
//        } else {
//            return ""
//        }
//    }
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Botón de regreso con círculo de progreso
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                    
//                    // Círculo de progreso al lado del botón de regreso
//                    if !progressText.isEmpty {
//                        ZStack {
//                            Circle()
//                                .fill(circleColor.opacity(circleOpacity))
//                                .frame(width: 40, height: 40)
//                            
//                            Text(progressText)
//                                .font(.caption)
//                                .bold()
//                                .foregroundColor(.black)
//                        }
//                        .padding(.trailing, 20)
//                    }
//                }
//                .padding(.top, 20)
//                
//                // Contenido
//                VStack(spacing: 25) {
//                    Text("Digital fast".localized)
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                    
//                    Image(systemName: "iphone.slash")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.white)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("Reclaim your attention from digital distractions. Break addictive screen habits to cultivate presence, focus, and authentic connection in the physical world.".localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("• First 60 minutes after waking: No screens".localized)
//                        Text("• Designate 3 screen-free hours daily".localized)
//                        Text("• Turn off all non-essential notifications".localized)
//                        Text("• No devices during meals or conversations".localized)
//                        Text("• Digital sunset 2 hours before bed".localized)
//                    }
//                    .font(.body)
//                    .foregroundColor(.white.opacity(0.9))
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                    
//                    // Información de progreso adicional
//                    if let progress = progress, progress.isStarted {
//                        VStack(spacing: 10) {
//                            if progress.isCompleted {
//                                Text("Challenge Completed!")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                            } else {
//                                Text("Progress: \(Int(progress.progressPercentage * 100))%")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                
//                                Text("Current Streak: \(progress.currentStreak) days")
//                                    .foregroundColor(.white.opacity(0.8))
//                                Text("Best Streak: \(progress.bestStreak) days")
//                                    .foregroundColor(.white.opacity(0.8))
//                            }
//                        }
//                        .padding()
//                        .background(Color.white.opacity(0.1))
//                        .cornerRadius(10)
//                    }
//                }
//                
//                Spacer()
//                
//                // Botones de acción condicionales
//                VStack(spacing: 15) {
//                    if let progress = progress {
//                        if progress.isCompleted {
//                            // Si ya está completado
//                            Text("✓ Challenge Completed")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white.opacity(0.2))
//                                .cornerRadius(15)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
//                                )
//                            
//                            Button(action: {
//                                progressManager.resetChallenge(challengeId)
//                            }) {
//                                Text("Restart Challenge".localized)
//                                    .font(.subheadline)
//                                    .foregroundColor(.white.opacity(0.8))
//                            }
//                            
//                        } else if progress.isStarted && !progress.isCompleted {
//                            // Si ya empezó pero no completó
//                            VStack(spacing: 15) {
//                                Button(action: {
//                                    progressManager.markDayCompleted(challengeId)
//                                }) {
//                                    Text("Mark Today as Completed".localized)
//                                        .font(.headline)
//                                        .foregroundColor(.white)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(Color.white.opacity(0.3))
//                                        .cornerRadius(15)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                        )
//                                }
//                                
//                                Button(action: {
//                                    progressManager.markChallengeCompleted(challengeId)
//                                }) {
//                                    Text("Complete Entire Challenge".localized)
//                                        .font(.headline)
//                                        .foregroundColor(.white)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(Color.white.opacity(0.2))
//                                        .cornerRadius(15)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                        )
//                                }
//                            }
//                            
//                        } else {
//                            // Si no ha empezado
//                            Button(action: {
//                                progressManager.startChallenge(challengeId, totalDays: 30)
//                            }) {
//                                Text("Start Challenge".localized)
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color.white.opacity(0.2))
//                                    .cornerRadius(15)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 15)
//                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                    )
//                            }
//                        }
//                    } else {
//                        // Estado inicial (no hay progreso)
//                        Button(action: {
//                            progressManager.startChallenge(challengeId, totalDays: 30)
//                        }) {
//                            Text("Start Challenge".localized)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white.opacity(0.2))
//                                .cornerRadius(15)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                                )
//                        }
//                    }
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 30)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//
//struct Challenge3View: View {
//    @Environment(\.dismiss) var dismiss
//    
//    @ObservedObject var progressManager: ChallengeProgressManager
//    private let challengeId = "challenge3"
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Botón de regreso
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // Contenido
//                VStack(spacing: 25) {
//                    Text("No Complaints".localized)
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                    
//                    Image(systemName: "person.spatialaudio.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.white)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("Replace complaining with constructive action. Train yourself to notice negative speech patterns and transform them into solution-oriented thinking.".localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("• Wear a bracelet/reminder (switch wrists when complaining)".localized)
//                        Text("• Practice 10-second pause before speaking".localized)
//                        Text("• Find one solution for every complaint voiced".localized)
//                        Text("• Reframe obstacles as opportunities".localized)
//                        Text("• Practice Stoic acceptance of things outside control".localized)
//                    }
//                    .font(.body)
//                    .foregroundColor(.white.opacity(0.9))
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                }
//                
//                Spacer()
//                
//                // Botón de acción
//                VStack(spacing: 15) {
//                    Button(action: {
//                        progressManager.startChallenge(challengeId)
//                    }) {
//                        Text("Start Challenge".localized)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .cornerRadius(15)
//                    }
//                    
//                    Button(action: {
//                        progressManager.markChallengeCompleted(challengeId)
//                    }) {
//                        Text("Mark as Completed".localized)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.8))
//                    }
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 30)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//struct Challenge4View: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var progressManager: ChallengeProgressManager
//    private let challengeId = "challenge4"
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Botón de regreso
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // Contenido
//                VStack(spacing: 25) {
//                    Text("Cold Exposure".localized)
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                    
//                    Image(systemName: "thermometer.snowflake")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.white)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("Build mental toughness through voluntary discomfort. Wear sweaters indoors, acclimate gradually, and build resilience through daily comfort reduction.".localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("• 1-minute cold shower finish".localized)
//                        Text("• Full cold shower".localized)
//                        Text("• Open windows at night".localized)
//                        Text("• Reduce heating your home".localized)
//                        Text("• Wear appropriate wool/sweaters instead of heating".localized)
//                    }
//                    .font(.body)
//                    .foregroundColor(.white.opacity(0.9))
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                }
//                
//                Spacer()
//                
//                // Botón de acción
//                VStack(spacing: 15) {
//                    Button(action: {
//                        progressManager.startChallenge(challengeId)
//                    }) {
//                        Text("Start Challenge".localized)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .cornerRadius(15)
//                    }
//                    
//                    Button(action: {
//                        progressManager.markChallengeCompleted(challengeId)
//                    }) {
//                        Text("Mark as Completed".localized)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.8))
//                    }
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 30)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//struct Challenge5View: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var progressManager: ChallengeProgressManager
//    private let challengeId = "challenge5"
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Botón de regreso
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // Contenido
//                VStack(spacing: 25) {
//                    Text("Early Wake".localized)
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                    
//                    Image(systemName: "sun.haze")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.white)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("Reclaim the quiet hours before the world wakes. Build discipline through consistent early rising, creating space for intentional living before daily demands consume your attention and energy.".localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("• Wake 30 minutes earlier".localized)
//                        Text("• Drink large glass of water".localized)
//                        Text("• One simple productive task".localized)
//                        Text("• Plan day's top 3 priorities".localized)
//                        Text("• Creative time with no interruptions (write, draw, create)".localized)
//                    }
//                    .font(.body)
//                    .foregroundColor(.white.opacity(0.9))
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                }
//                
//                Spacer()
//                
//                // Botón de acción
//                VStack(spacing: 15) {
//                    Button(action: {
//                        progressManager.startChallenge(challengeId)
//                    }) {
//                        Text("Start Challenge".localized)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .cornerRadius(15)
//                    }
//                    
//                    Button(action: {
//                        progressManager.markChallengeCompleted(challengeId)
//                    }) {
//                        Text("Mark as Completed".localized)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.8))
//                    }
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 30)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//struct Challenge6View: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var progressManager: ChallengeProgressManager
//    private let challengeId = "challenge6"
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Botón de regreso
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // Contenido
//                VStack(spacing: 25) {
//                    Text("Journaling".localized)
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                    
//                    Image(systemName: "highlighter")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.white)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("Transform random thoughts into structured wisdom through daily Stoic journaling. Move from mental clutter to philosophical clarity by systematically examining your day through the lens of Stoic principles.".localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("• 10 minutes before bed: Review your day".localized)
//                        Text("• What went well? (3 things)".localized)
//                        Text("• Write a conversation with a Stoic philosopher".localized)
//                        Text("• Never take advice from someone who you wouldn’t trade your life with".localized)
//                        Text("• Establish some definite discipline and rules for yourself".localized)
//                    }
//                    .font(.body)
//                    .foregroundColor(.white.opacity(0.9))
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                }
//                
//                Spacer()
//                
//                // Botón de acción
//                VStack(spacing: 15) {
//                    Button(action: {
//                        progressManager.startChallenge(challengeId)
//                    }) {
//                        Text("Start Challenge".localized)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .cornerRadius(15)
//                    }
//                    
//                    Button(action: {
//                        progressManager.markChallengeCompleted(challengeId)
//                    }) {
//                        Text("Mark as Completed".localized)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.8))
//                    }
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 30)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//
//
//struct Challenge7View: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var progressManager: ChallengeProgressManager
//    private let challengeId = "challenge7"
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Botón de regreso
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // Contenido
//                VStack(spacing: 25) {
//                    Text("Conscious Consumption".localized)
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                    
//                    Image(systemName: "shekelsign.arrow.trianglehead.counterclockwise.rotate.90")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.white)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("Question every desire before acting on it. Practice the Stoic pause between impulse and action to cultivate wisdom in consumption.".localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("• Wait 24 hours before any non-essential purchase".localized)
//                        Text("• Ask: 'Is this a want or a need?' ".localized)
//                        Text("• Track all spending consciously".localized)
//                        Text("• One day per week: No spending".localized)
//                        Text("• Donate one item for every new item".localized)
//                        
//                    }
//                    .font(.body)
//                    .foregroundColor(.white.opacity(0.9))
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                }
//                
//                Spacer()
//                
//                // Botón de acción
//                VStack(spacing: 15) {
//                    Button(action: {
//                        progressManager.startChallenge(challengeId)
//                    }) {
//                        Text("Start Challenge".localized)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .cornerRadius(15)
//                    }
//                    
//                    Button(action: {
//                        progressManager.markChallengeCompleted(challengeId)
//                    }) {
//                        Text("Mark as Completed".localized)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.8))
//                    }
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 30)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//
//struct Challenge8View: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var progressManager: ChallengeProgressManager
//    private let challengeId = "challenge8"
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.gray]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Botón de regreso
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                .padding(.top, 20)
//                
//                // Contenid"Delayed Gratification Mastery"o
//                VStack(spacing: 25) {
//                    Text("Delayed Gratification Mastery".localized)
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                    
//                    Image(systemName: "apple.meditate")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.white)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Challenge Description".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("Master the art of waiting. Train yourself to value future abundance over immediate pleasure to build profound patience and long-term thinking.".localized)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.3))
//                        
//                        Text("Daily Task".localized)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        Text("• Save first, buy later".localized)
//                        Text("• What you plant today, others/God/future-you will enjoy".localized)
//                        Text("• Create '3-Year Waiting List' for desired items".localized)
//                        Text("• Fix something broken instead of buying new".localized)
//                        Text("• For each resisted purchase, transfer amount to savings".localized)
//                    }
//                    .font(.body)
//                    .foregroundColor(.white.opacity(0.9))
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                    .padding(.horizontal, 20)
//                }
//                
//                Spacer()
//                
//                // Botón de acción
//                VStack(spacing: 15) {
//                    Button(action: {
//                        progressManager.startChallenge(challengeId)
//                    }) {
//                        Text("Start Challenge".localized)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .cornerRadius(15)
//                    }
//                    
//                    Button(action: {
//                        progressManager.markChallengeCompleted(challengeId)
//                    }) {
//                        Text("Mark as Completed".localized)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.8))
//                    }
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 30)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//#Preview {
//    ChallengesView()
//}



// MARK: - Models
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

struct ChallengeData: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let description: String
    let tasks: [String]
    
    static let allChallenges: [ChallengeData] = [
        ChallengeData(
            id: "challenge1",
            title: "Memento Mori",
            subtitle: "Daily reflection",
            icon: "hourglass",
            description: "Practice daily reflection on mortality to appreciate the present moment and live intentionally.",
            tasks: [
                "Write for 5 minutes each morning about your mortality",
                "Reflect on what truly matters in your life",
                "Appreciate one thing you often take for granted",
                "Set an intention for the day"
            ]
        ),
        ChallengeData(
            id: "challenge2",
            title: "Digital fast",
            subtitle: "Get back the focus",
            icon: "iphone.slash",
            description: "Reclaim your attention from digital distractions. Break addictive screen habits to cultivate presence, focus, and authentic connection in the physical world.",
            tasks: [
                "First 60 minutes after waking: No screens",
                "Designate 3 screen-free hours daily",
                "Turn off all non-essential notifications",
                "No devices during meals or conversations",
                "Digital sunset 2 hours before bed"
            ]
        ),
        ChallengeData(
            id: "challenge3",
            title: "No Complaints",
            subtitle: "Mindfulness",
            icon: "person.spatialaudio.fill",
            description: "Replace complaining with constructive action. Train yourself to notice negative speech patterns and transform them into solution-oriented thinking.",
            tasks: [
                "Wear a bracelet/reminder (switch wrists when complaining)",
                "Practice 10-second pause before speaking",
                "Find one solution for every complaint voiced",
                "Reframe obstacles as opportunities",
                "Practice Stoic acceptance of things outside control"
            ]
        ),
        ChallengeData(
            id: "challenge4",
            title: "Cold Exposure",
            subtitle: "30 days challenge",
            icon: "thermometer.snowflake",
            description: "Build mental toughness through voluntary discomfort. Wear sweaters indoors, acclimate gradually, and build resilience through daily comfort reduction.",
            tasks: [
                "1-minute cold shower finish",
                "Full cold shower",
                "Open windows at night",
                "Reduce heating your home",
                "Wear appropriate wool/sweaters instead of heating"
            ]
        ),
        ChallengeData(
            id: "challenge5",
            title: "Early Wake",
            subtitle: "Discipline",
            icon: "sun.haze",
            description: "Reclaim the quiet hours before the world wakes. Build discipline through consistent early rising, creating space for intentional living before daily demands consume your attention and energy.",
            tasks: [
                "Wake 30 minutes earlier",
                "Drink large glass of water",
                "One simple productive task",
                "Plan day's top 3 priorities",
                "Creative time with no interruptions (write, draw, create)"
            ]
        ),
        ChallengeData(
            id: "challenge6",
            title: "Journaling",
            subtitle: "Self-awareness",
            icon: "book.fill",
            description: "Transform random thoughts into structured wisdom through daily Stoic journaling. Move from mental clutter to philosophical clarity by systematically examining your day through the lens of Stoic principles.",
            tasks: [
                "10 minutes before bed: Review your day",
                "What went well? (3 things)",
                "Write a conversation with a Stoic philosopher",
                "Never take advice from someone who you wouldn't trade your life with",
                "Establish some definite discipline and rules for yourself"
            ]
        ),
        ChallengeData(
            id: "challenge7",
            title: "Consumption",
            subtitle: "Question your desire",
            icon: "sterlingsign.ring.dashed",
            description: "Question every desire before acting on it. Practice the Stoic pause between impulse and action to cultivate wisdom in consumption.",
            tasks: [
                "Wait 24 hours before any non-essential purchase",
                "Ask: 'Is this a want or a need?'",
                "Track all spending consciously",
                "One day per week: No spending",
                "Donate one item for every new item"
            ]
        ),
        ChallengeData(
            id: "challenge8",
            title: "Gratification",
            subtitle: "Do what matters",
            icon: "figure.mind.and.body",
            description: "Master the art of waiting. Train yourself to value future abundance over immediate pleasure to build profound patience and long-term thinking.",
            tasks: [
                "Save first, buy later",
                "What you plant today, others/God/future-you will enjoy",
                "Create '3-Year Waiting List' for desired items",
                "Fix something broken instead of buying new",
                "For each resisted purchase, transfer amount to savings"
            ]
        )
    ]
}

// MARK: - Progress Manager
class ChallengeProgressManager: ObservableObject {
    @Published var challengesProgress: [String: ChallengeProgress] = [:]
    
    init() {
        loadProgress()
        initializeMissingChallenges()
    }
    
    private func initializeMissingChallenges() {
        for challenge in ChallengeData.allChallenges {
            if challengesProgress[challenge.id] == nil {
                challengesProgress[challenge.id] = ChallengeProgress(challengeId: challenge.id)
            }
        }
        saveProgress()
    }
    
    // MARK: - Challenge Operations
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
    
    // MARK: - Statistics
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
    
    // MARK: - Date Helpers
    func canIncrementCounter(for challengeId: String) -> Bool {
        let key = "lastDatePracticed_\(challengeId)"
        let lastDate = UserDefaults.standard.string(forKey: key) ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = formatter.string(from: Date())
        
        return lastDate != currentDateString
    }
    
    func saveCurrentDate(for challengeId: String) {
        let key = "lastDatePracticed_\(challengeId)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = formatter.string(from: Date())
        
        UserDefaults.standard.set(currentDateString, forKey: key)
    }
    
    // MARK: - Persistence
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

// MARK: - Challenge Detail View
struct ChallengeDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var progressManager: ChallengeProgressManager
    
    let challengeData: ChallengeData
    
    private var progress: ChallengeProgress? {
        progressManager.getProgress(challengeData.id)
    }
    
    private var canIncrement: Bool {
        progressManager.canIncrementCounter(for: challengeData.id)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Content
                ScrollView {
                    VStack(spacing: 25) {
                        // Title and Icon
                        if let progress = progress, !progress.isStarted {
                            Text(challengeData.title.localized)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Image(systemName: challengeData.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                        } else {
                            Text(challengeData.title.localized)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Image(systemName: challengeData.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        
                        // Description and Tasks
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Challenge Description".localized)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text(challengeData.description.localized)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Divider()
                                .background(Color.white.opacity(0.3))
                            
                            Text("Daily Task".localized)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            ForEach(challengeData.tasks, id: \.self) { task in
                                Text("• \(task.localized)")
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        .font(.body)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        
                        // Progress Info
                        if let progress = progress, progress.isStarted && !progress.isCompleted {
                            VStack(spacing: 10) {
                                Text("Progress: \(Int(progress.progressPercentage * 100))%")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("Current Streak: \(progress.currentStreak) days")
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Best Streak: \(progress.bestStreak) days")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 15) {
                        if let progress = progress {
                            if progress.isCompleted {
                                // Challenge Completed
                                Text("✓ Challenge Completed")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                    )
                                
                                Button(action: {
                                    progressManager.resetChallenge(challengeData.id)
                                }) {
                                    Text("Restart Challenge".localized)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                            } else if progress.isStarted && !progress.isCompleted {
                                // Challenge in Progress
                                VStack(spacing: 15) {
                                    if canIncrement {
                                        Button(action: {
                                            progressManager.markDayCompleted(challengeData.id)
                                            progressManager.saveCurrentDate(for: challengeData.id)
                                        }) {
                                            Text("Mark Today as Completed".localized)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(Color.white.opacity(0.3))
                                                .cornerRadius(15)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                                )
                                        }
                                    } else {
                                        Button(action: {}) {
                                            Text("Completed Today ✓")
                                                .font(.headline)
                                                .foregroundColor(.white.opacity(0.6))
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(Color.white.opacity(0.1))
                                                .cornerRadius(15)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                                )
                                        }
                                        .disabled(true)
                                    }
                                    
                                    Button(action: {
                                        progressManager.markChallengeCompleted(challengeData.id)
                                    }) {
                                        Text("Complete Entire Challenge".localized)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(15)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                            )
                                    }
                                }
                                
                            } else {
                                // Challenge Not Started
                                Button(action: {
                                    progressManager.startChallenge(challengeData.id, totalDays: 30)
                                }) {
                                    Text("Start Challenge".localized)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                        )
                                }
                            }
                        } else {
                            // Initial State
                            Button(action: {
                                progressManager.startChallenge(challengeData.id, totalDays: 30)
                            }) {
                                Text("Start Challenge".localized)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Individual Challenge Views (Simplified)
struct Challenge1View: View {
    @ObservedObject var progressManager: ChallengeProgressManager
    
    var body: some View {
        ChallengeDetailView(
            progressManager: progressManager,
            challengeData: ChallengeData.allChallenges[0]
        )
    }
}

struct Challenge2View: View {
    @ObservedObject var progressManager: ChallengeProgressManager
    
    var body: some View {
        ChallengeDetailView(
            progressManager: progressManager,
            challengeData: ChallengeData.allChallenges[1]
        )
    }
}

struct Challenge3View: View {
    @ObservedObject var progressManager: ChallengeProgressManager
    
    var body: some View {
        ChallengeDetailView(
            progressManager: progressManager,
            challengeData: ChallengeData.allChallenges[2]
        )
    }
}

struct Challenge4View: View {
    @ObservedObject var progressManager: ChallengeProgressManager
    
    var body: some View {
        ChallengeDetailView(
            progressManager: progressManager,
            challengeData: ChallengeData.allChallenges[3]
        )
    }
}

struct Challenge5View: View {
    @ObservedObject var progressManager: ChallengeProgressManager
    
    var body: some View {
        ChallengeDetailView(
            progressManager: progressManager,
            challengeData: ChallengeData.allChallenges[4]
        )
    }
}

struct Challenge6View: View {
    @ObservedObject var progressManager: ChallengeProgressManager
    
    var body: some View {
        ChallengeDetailView(
            progressManager: progressManager,
            challengeData: ChallengeData.allChallenges[5]
        )
    }
}

struct Challenge7View: View {
    @ObservedObject var progressManager: ChallengeProgressManager
    
    var body: some View {
        ChallengeDetailView(
            progressManager: progressManager,
            challengeData: ChallengeData.allChallenges[6]
        )
    }
}

struct Challenge8View: View {
    @ObservedObject var progressManager: ChallengeProgressManager
    
    var body: some View {
        ChallengeDetailView(
            progressManager: progressManager,
            challengeData: ChallengeData.allChallenges[7]
        )
    }
}

// MARK: - Main Challenges View (Optimized)
public struct ChallengesView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var progressManager = ChallengeProgressManager()
    
    public var body: some View {
        let backImage = colorScheme == .dark ? "BackDarkMarco" : "BackLightMarco"
        
        NavigationStack {
            ZStack(alignment: .center) {
                // Background
                Image(backImage)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Content
                ScrollView {
                    VStack(alignment: .center, spacing: 30) {
                        // Header
                        VStack(spacing: 15) {
                            Text("Challenges List".localized)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                                .shadow(radius: 3)
                            
                            // Statistics
                            VStack(spacing: 15) {
                                Text("Your Progress".localized)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .opacity(0.7)
                                
                                HStack(spacing: 30) {
                                    ProgressStat(
                                        value: "\(progressManager.getCompletedCount())",
                                        label: "Completed".localized,
                                        opacity: 0.4
                                    )
                                    
                                    ProgressStat(
                                        value: "\(progressManager.getInProgressCount())",
                                        label: "In Progress".localized,
                                        opacity: 0.6
                                    )
                                    
                                    ProgressStat(
                                        value: "\(progressManager.getAvailableCount())",
                                        label: "Available".localized,
                                        opacity: 0.8
                                    )
                                }
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                        }
                        .padding(.top, 40)
                        
                        // Challenge Grid
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                            ForEach(ChallengeData.allChallenges) { challenge in
                                ChallengeCard(
                                    title: challenge.title,
                                    subtitle: challenge.subtitle,
                                    icon: challenge.icon,
                                    progress: progressManager.getProgress(challenge.id),
                                    destination: getDestinationView(for: challenge)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    @ViewBuilder
    private func getDestinationView(for challenge: ChallengeData) -> some View {
        switch challenge.id {
        case "challenge1":
            Challenge1View(progressManager: progressManager)
        case "challenge2":
            Challenge2View(progressManager: progressManager)
        case "challenge3":
            Challenge3View(progressManager: progressManager)
        case "challenge4":
            Challenge4View(progressManager: progressManager)
        case "challenge5":
            Challenge5View(progressManager: progressManager)
        case "challenge6":
            Challenge6View(progressManager: progressManager)
        case "challenge7":
            Challenge7View(progressManager: progressManager)
        case "challenge8":
            Challenge8View(progressManager: progressManager)
        default:
            EmptyView()
        }
    }
}

// MARK: - Supporting Views (Keep your existing ChallengeCard and ProgressStat views)
// These remain the same as in your original code

#Preview {
    ChallengesView()
}
