//
//  TrackView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 06/01/2026.
//


import Combine
import Foundation
import SwiftUI
import Lottie

// MARK: - Models for Goal System
struct StoicGoal: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var category: GoalCategory
    var priority: PriorityLevel
    var targetDate: Date?
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?
    var progress: Double // 0.0 to 1.0
    var dailyAction: String
    var weeklyReview: String
    
    init(title: String, description: String, category: GoalCategory, priority: PriorityLevel = .medium) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.priority = priority
        self.isCompleted = false
        self.createdAt = Date()
        self.progress = 0.0
        self.dailyAction = ""
        self.weeklyReview = ""
    }
}

enum GoalCategory: String, CaseIterable, Codable {
    case character = "Character & Virtue"
    case career = "Career & Contribution"
    case health = "Health & Discipline"
    case relationships = "Relationships"
    case learning = "Learning & Wisdom"
    case financial = "Financial Wisdom"
    case legacy = "Legacy & Impact"
    
    var icon: String {
        switch self {
        case .character: return "figure.mind.and.body"
        case .career: return "briefcase.fill"
        case .health: return "heart.fill"
        case .relationships: return "person.2.fill"
        case .learning: return "brain.head.profile"
        case .financial: return "chart.line.uptrend.xyaxis"
        case .legacy: return "sparkles"
        }
    }
    
    var stoicQuote: String {
        switch self {
        case .character: return "Waste no more time arguing what a good man should be. Be one."
        case .career: return "Whatever you do, do it with excellence."
        case .health: return "The body is our primary tool. Keep it sharp and ready."
        case .relationships: return "What is not good for the swarm is not good for the bee."
        case .learning: return "The mind is not a vessel to be filled but a fire to be kindled."
        case .financial: return "Wealth consists not in having great possessions, but in having few wants."
        case .legacy: return "Think of yourself as dead. You have lived your life. Now, take what's left and live it properly."
        }
    }
}

enum PriorityLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .blue
        case .high: return .orange
        case .critical: return .red
        }
    }
}

// MARK: - Stoic Principles Guide
struct StoicPrinciple: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let habitRelation: String
    let actionStep: String
    
    static let stoicHabits: [StoicPrinciple] = [
        StoicPrinciple(
            title: "Be Proactive (The Discipline of Assent)",
            description: "Between stimulus and response, there is a space. In that space is our power to choose our response.",
            habitRelation: "Habit 1: Be Proactive",
            actionStep: "Identify one automatic reaction and consciously choose a different response"
        ),
        StoicPrinciple(
            title: "Begin with the End in Mind (Memento Mori)",
            description: "Live each day as if it were your last. What would you want to have accomplished? This Stoic practice aligns with habit 2, focusing on what truly matters.",
            habitRelation: "Habit 2: Begin with the End in Mind",
            actionStep: "Write your eulogy. What would you want to be remembered for?"
        ),
        StoicPrinciple(
            title: "Put First Things First (Dichotomy of Control)",
            description: "Focus only on what you can control. Your actions, judgments, and responses. Let go of external outcomes.",
            habitRelation: "Habit 3: Put First Things First",
            actionStep: "Create a daily list separating: 1) What you control 2) What you don't"
        ),
        StoicPrinciple(
            title: "Think Win-Win (Sympatheia)",
            description: "The Stoic concept of interconnectedness. Understand that helping others helps the whole community, which includes yourself.",
            habitRelation: "Habit 4: Think Win-Win",
            actionStep: "Identify one relationship where you can create mutual benefit today"
        ),
        StoicPrinciple(
            title: "Seek First to Understand (Objective Judgment)",
            description: "Practice seeing things as they are, not as you wish them to be. Remove emotional coloring from your perceptions.",
            habitRelation: "Habit 5: Seek First to Understand, Then to Be Understood",
            actionStep: "Listen without judgment for 5 minutes to someone you disagree with"
        ),
        StoicPrinciple(
            title: "Synergize (Universal Reason)",
            description: "Everything in the universe works together according to rational principles. Find harmony in collaboration.",
            habitRelation: "Habit 6: Synergize",
            actionStep: "Combine two different skills or perspectives to solve a problem"
        ),
        StoicPrinciple(
            title: "Sharpen the Saw (Morning & Evening Meditation)",
            description: "Daily practice of morning preparation and evening review - the Stoic disciplines of assent, desire, and action.",
            habitRelation: "Habit 7: Sharpen the Saw",
            actionStep: "Create a 10-minute morning ritual of intention setting"
        )
        
    ]
}

// MARK: - Goal Manager
class GoalManager: ObservableObject {
    @Published var goals: [StoicGoal] = []
    @Published var weeklyReviewAnswers: [String] = Array(repeating: "", count: 7)
    
    private let goalsKey = "stoicGoals"
    private let reviewKey = "weeklyReviewAnswers"
    
    init() {
        loadGoals()
        loadWeeklyReview()
    }
    
    // MARK: - Goal Operations
    func addGoal(_ goal: StoicGoal) {
        goals.append(goal)
        saveGoals()
    }
    
    func updateGoal(_ goal: StoicGoal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveGoals()
        }
    }
    
    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
        saveGoals()
    }
    
    func updateProgress(for goalId: UUID, progress: Double) {
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            goals[index].progress = min(1.0, max(0.0, progress))
            if progress >= 1.0 && !goals[index].isCompleted {
                goals[index].isCompleted = true
                goals[index].completedAt = Date()
            }
            saveGoals()
        }
    }
    
    func completeGoal(_ goalId: UUID) {
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            goals[index].isCompleted = true
            goals[index].progress = 1.0
            goals[index].completedAt = Date()
            saveGoals()
        }
    }
    
    // MARK: - Weekly Review
    func saveWeeklyReviewAnswer(_ answer: String, at index: Int) {
        guard index >= 0 && index < weeklyReviewAnswers.count else { return }
        weeklyReviewAnswers[index] = answer
        saveWeeklyReview()
    }
    
    // MARK: - Statistics
    var completedGoalsCount: Int {
        goals.filter { $0.isCompleted }.count
    }
    
    var totalGoalsCount: Int {
        goals.count
    }
    
    var averageProgress: Double {
        guard !goals.isEmpty else { return 0 }
        return goals.reduce(0) { $0 + $1.progress } / Double(goals.count)
    }
    
    var goalsByCategory: [GoalCategory: [StoicGoal]] {
        Dictionary(grouping: goals, by: { $0.category })
    }
    
    // MARK: - Persistence
    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
    }
    
    private func loadGoals() {
        if let savedData = UserDefaults.standard.data(forKey: goalsKey),
           let decoded = try? JSONDecoder().decode([StoicGoal].self, from: savedData) {
            goals = decoded
        }
    }
    
    private func saveWeeklyReview() {
        UserDefaults.standard.set(weeklyReviewAnswers, forKey: reviewKey)
    }
    
    private func loadWeeklyReview() {
        if let saved = UserDefaults.standard.array(forKey: reviewKey) as? [String] {
            weeklyReviewAnswers = saved
        }
    }
}

// MARK: - Main Goals View
struct GoalsView: View {
    @State private var showingQuote = false
    @State private var currentRandomQuote: String = ""
    @State private var showNinjatoAnimation = false
    @State private var ninjatoPlayback: LottiePlaybackMode = .paused(at: .progress(0))
    @State private var selectedTab = 0
    
    @StateObject private var goalManager = GoalManager()
    @StateObject private var langManager = LocalizationManager.shared
    
    @AppStorage("daysPracticed") private var daysPracticed: Int = 0
    @AppStorage("lastDatePracticed") private var lastDatePracticed: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    
    private var appScheme: AppColorScheme {
        AppColorScheme(rawValue: storedScheme) ?? .system
    }
    
    private let allQuotes: [AppLanguage: [String]] = [
        .english: stoicGoalQuotesEng,
        .spanish: stoicGoalQuotesES,
        .french: stoicGoalQuotesFr
    ]
    
    // MARK: - View States
    @State private var showingAddGoalSheet = false
    @State private var showingWeeklyReviewSheet = false
    @State private var showingQuoteSheet = false
    
    var body: some View {
        let lottieBack = (colorScheme == .dark) ? "BackDarkDev" : "BackLightMolido"
        
        NavigationStack {
            ZStack(alignment: .center) {
                // Fondo animado
                LottieView(animation: .named(lottieBack))
                    .configure { lottie in
                        lottie.contentMode = .scaleAspectFill
                        lottie.animationSpeed = 0.5
                    }
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .resizable()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .brightness(-0.5)
                
                // Contenido principal
                TabView(selection: $selectedTab) {
                    // Tab 1: Vista Principal (Inspiración)
                    mainInspirationView
                        .tag(0)
                    
                    // Tab 2: Lista de Objetivos
                    goalsListView
                        .tag(1)
                    
                    // Tab 3: 7 Hábitos Stoic
                    stoicHabitsView
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .overlay(alignment: .bottom) {
                    GoalsTabBar(selectedTab: $selectedTab)
                }
                
            }
        }
        .sheet(isPresented: $showingAddGoalSheet) {
            AddGoalView(goalManager: goalManager)
        }
        .sheet(isPresented: $showingWeeklyReviewSheet) {
            WeeklyReviewView(goalManager: goalManager)
        }
        .sheet(isPresented: $showingQuoteSheet) {
            QuoteSheetView(isPresented: $showingQuoteSheet, quote: currentRandomQuote)
        }
    }
    
    // MARK: - Helper Methods
    private func canIncrementCounter() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = formatter.string(from: Date())
        return lastDatePracticed != currentDateString
    }
    
    private func markDayAsMindful() {
        if canIncrementCounter() {
            daysPracticed += 1
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            lastDatePracticed = formatter.string(from: Date())
            
            // Trigger animation
            showNinjatoAnimation = true
            ninjatoPlayback = .playing(.toProgress(1, loopMode: .playOnce))
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

// MARK: - View Components
extension GoalsView {
    private var mainInspirationView: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Stoic Goals")
                        .font(.system(size: 48, weight: .heavy, design: .serif))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    
                    Text("Wisdom through intentional action".localized)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.9))
                        .italic()
                }
                .padding(.top, 40)
                
                // Quick Stats
                HStack(spacing: 20) {
                    StatsCard(
                        value: "\(goalManager.completedGoalsCount)",
                        label: "Completed",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                    
                    StatsCard(
                        value: "\(Int(goalManager.averageProgress * 100))%",
                        label: "Progress",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .blue
                    )
                    
                    StatsCard(
                        value: "\(goalManager.goals.count)",
                        label: "Active",
                        icon: "target",
                        color: .orange
                    )
                }
                .padding(.horizontal)
                
                // Mindful Days Counter (from your original)
//                VStack {
//                    Text("\(daysPracticed)")
//                        .font(.system(size: 80, weight: .bold, design: .serif))
//                        .foregroundStyle(.white)
//                    
//                    Text("Days lived mindfully".localized)
//                        .font(.headline)
//                        .foregroundStyle(.white.opacity(0.8))
//                        .shadow(radius: 3)
//                }
//                .padding(30)
//                .background(.ultraThinMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 30))
//                .padding(.horizontal, 20)
//                .onTapGesture {
//                    if canIncrementCounter() {
//                        markDayAsMindful()
//                    }
//                }
                
                // Quick Actions
                VStack(spacing: 15) {
                    ActionButton(
                        title: "Set New Goal".localized,
                        icon: "plus.circle.fill",
                        color: .blue,
                        action: {
                            selectedTab = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showingAddGoalSheet = true
                            }
                        }
                    )
                    
                    ActionButton(
                        title: "Weekly review".localized,
                        icon: "quote.bubble.fill",
                        color: .purple,
                        action:  { showingWeeklyReviewSheet = true }
                    )
                    
                    ActionButton(
                        title: "Stoic Habits".localized,
                        icon: "brain.head.profile",
                        color: .green,
                        action: { selectedTab = 2 }
                    )
                }
                .padding(.horizontal, 20)
                
                // Recent Goals Preview
                if !goalManager.goals.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Recent Goals")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button("See All") {
                                selectedTab = 1
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(goalManager.goals.prefix(3)) { goal in
                                    GoalPreviewCard(goal: goal)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
    }
    
    private var goalsListView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Text("Your Stoic Goals".localized)
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                    
                    Text("What you can control, improve".localized)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.top, 40)
                
                // Goals List
                if goalManager.goals.isEmpty {
                    EmptyGoalsView()
                        .padding(.horizontal, 20)
                } else {
                    ForEach(goalManager.goals) { goal in
                        GoalCard(goal: goal, goalManager: goalManager)
                            .padding(.horizontal, 20)
                    }
                }
                
                // Add Goal Button
                Button(action: { showingAddGoalSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Goal".localized)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer(minLength: 150)
            }
        }
    }
    
    private var stoicHabitsView: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 10) {
                    Text("7 Stoic Habits".localized)
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                    
                    Text("Ancient wisdom for modern effectiveness".localized)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.8))
                        .italic()
                }
                .padding(.top, 40)
                
                // Habits List
                ForEach(StoicPrinciple.stoicHabits) { principle in
                    StoicHabitCard(principle: principle)
                        .padding(.horizontal, 20)
                }
                
                // Weekly Review Prompt
                VStack(spacing: 15) {
                    Text("Weekly Stoic Review".localized)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Take time each week to reflect on your progress and alignment with Stoic principles.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Button("Start Weekly Review") {
                        showingWeeklyReviewSheet = true
                    }
                    .padding()
                    .background(Color.orange.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer(minLength: 150)
            }
        }
    }
}

// MARK: - Supporting Views
struct GoalsTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                Button(action: { withAnimation { selectedTab = index } }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabIcon(for: index))
                            .font(.title2)
                        Text(tabTitle(for: index))
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == index ? .white : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedTab == index ? Color.white.opacity(0.2) : Color.clear)
                }
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "target"
        case 2: return "brain.head.profile"
        default: return "circle"
        }
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Home".localized
        case 1: return "Goals".localized
        case 2: return "Habits".localized
        default: return ""
        }
    }
}

struct StatsCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
            
            Text(label.localized)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
        }
    }
}

struct GoalPreviewCard: View {
    let goal: StoicGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: goal.category.icon)
                    .foregroundColor(goal.priority.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(goal.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(goal.priority.color)
                        .frame(width: geometry.size.width * goal.progress, height: 4)
                }
            }
            .frame(height: 4)
            
            Text("\(Int(goal.progress * 100))% complete")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(width: 250)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}

struct GoalCard: View {
    let goal: StoicGoal
    @ObservedObject var goalManager: GoalManager
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: goal.category.icon)
                        .foregroundColor(goal.priority.color)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(goal.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text(goal.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    if goal.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    }
                }
                
                // Progress Bar
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("\(Int(goal.progress * 100))%")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text(goal.priority.rawValue)
                            .font(.caption)
                            .foregroundColor(goal.priority.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(goal.priority.color.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(goal.priority.color)
                                .frame(width: geometry.size.width * goal.progress, height: 6)
                                .cornerRadius(3)
                                .animation(.easeInOut, value: goal.progress)
                        }
                    }
                    .frame(height: 6)
                }
                
                if !goal.dailyAction.isEmpty {
                    Text("Daily: \(goal.dailyAction)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            GoalDetailView(goal: goal, goalManager: goalManager)
        }
    }
}

struct EmptyGoalsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.5))
            
            VStack(spacing: 10) {
                Text("No goals yet".localized)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text("""
                "First say to yourself what you would be; 
                and then do what you have to do."
                """)
                .font(.body)
                .italic()
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                
                Text("- Epictetus")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(40)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

struct StoicHabitCard: View {
    let principle: StoicPrinciple
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(principle.habitRelation)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .bold()
                    
                    Text(principle.title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            
            Text(principle.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Stoic Action:")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                
                Text(principle.actionStep)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}

// MARK: - Quote Data
let stoicGoalQuotesEng = [
    "The impediment to action advances action. What stands in the way becomes the way.",
    "You have power over your mind - not outside events. Realize this, and you will find strength.",
    "Waste no more time arguing what a good man should be. Be one.",
    "The happiness of your life depends upon the quality of your thoughts.",
    "We suffer more often in imagination than in reality.",
    "He who fears death will never do anything worthy of a living man.",
    "First say to yourself what you would be; and then do what you have to do.",
    "No man is free who is not master of himself.",
    "It's not what happens to you, but how you react to it that matters.",
    "The soul becomes dyed with the color of its thoughts.",
    "If it is not right, do not do it. If it is not true, do not say it.",
    "The best revenge is to be unlike him who performed the injury.",
    "Receive without pride, let go without attachment.",
    "When you arise in the morning, think of what a precious privilege it is to be alive.",
    "Very little is needed to make a happy life; it is all within yourself, in your way of thinking."
]

let stoicGoalQuotesES = [
    "El obstáculo para la acción avanza la acción. Lo que se interpone en el camino se convierte en el camino.",
    "Tienes poder sobre tu mente, no sobre los eventos externos. Date cuenta de esto y encontrarás fuerza.",
    "No pierdas más tiempo discutiendo cómo debería ser un buen hombre. Sé uno.",
    "La felicidad de tu vida depende de la calidad de tus pensamientos.",
    "Sufrimos más a menudo en la imaginación que en la realidad.",
    "Quien teme a la muerte nunca hará nada digno de un hombre vivo.",
    "Primero dígase a sí mismo lo que sería; y luego haga lo que tiene que hacer.",
    "Ningún hombre es libre si no es dueño de sí mismo.",
    "No es lo que te pasa, sino cómo reaccionas lo que importa.",
    "El alma se tiñe con el color de sus pensamientos.",
    "Si no es correcto, no lo hagas. Si no es verdad, no lo digas.",
    "La mejor venganza es no ser como quien causó la ofensa.",
    "Recibe sin orgullo, suelta sin apego.",
    "Cuando te levantes por la mañana, piensa en el precioso privilegio que es estar vivo.",
    "Muy poco se necesita para hacer una vida feliz; todo está dentro de ti, en tu forma de pensar."
]

let stoicGoalQuotesFr = [
    "L'obstacle à l'action fait avancer l'action. Ce qui se dresse sur le chemin devient le chemin.",
    "Vous avez du pouvoir sur votre esprit - pas sur les événements extérieurs. Réalisez cela et vous trouverez la fuerza.",
    "Ne perdez plus de temps à discuter de ce qu'un homme bon devrait être. Soyez-en un.",
    "Le bonheur de votre vie dépend de la qualité de vos pensées.",
    "Nous souffrons plus souvent dans l'imagination que dans la réalité.",
    "Celui qui craint la mort ne fera jamais rien digne d'un homme vivant.",
    "Dites-vous d'abord ce que vous seriez ; puis faites ce que vous avez à faire.",
    "Aucun homme n'est libre s'il n'est pas maître de lui-même.",
    "Ce n'est pas ce qui vous arrive, mais comment vous y réagissez qui compte.",
    "L'âme se teint de la couleur de ses pensées.",
    "Si ce n'est pas juste, ne le faites pas. Si ce n'est pas vrai, ne le dites pas.",
    "La meilleure vengeance est de ne pas être comme celui qui a commis l'injure.",
    "Recevez sans fierté, laissez aller sans attachement.",
    "Quand vous vous levez le matin, pensez au précieux privilège qu'est d'être en vie.",
    "Très peu est nécessaire pour faire une vie heureuse ; tout est en vous, dans votre façon de penser."
]

// MARK: - Additional Views (Add these in the same file or separate files)

struct AddGoalView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var goalManager: GoalManager
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: GoalCategory = .character
    @State private var selectedPriority: PriorityLevel = .medium
    @State private var targetDate = Date().addingTimeInterval(30 * 24 * 3600)
    @State private var dailyAction = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("What do you want to achieve?", text: $title)
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(GoalCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    
                    Text(selectedCategory.stoicQuote)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .italic()
                }
                
                Section(header: Text("Priority & Timeline")) {
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(PriorityLevel.allCases, id: \.self) { priority in
                            Text(priority.rawValue)
                                .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    DatePicker("Target Date", selection: $targetDate, in: Date()..., displayedComponents: .date)
                }
                
                Section(header: Text("Daily Stoic Action")) {
                    TextField("What will you do today to move forward?", text: $dailyAction)
                }
            }
            .navigationTitle("New Stoic Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGoal()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveGoal() {
        var goal = StoicGoal(
            title: title,
            description: description,
            category: selectedCategory,
            priority: selectedPriority
        )
        goal.targetDate = targetDate
        goal.dailyAction = dailyAction
        
        goalManager.addGoal(goal)
        dismiss()
    }
}

struct GoalDetailView: View {
    let goal: StoicGoal
    @ObservedObject var goalManager: GoalManager
    @Environment(\.dismiss) var dismiss
    
    @State private var progress: Double
    
    init(goal: StoicGoal, goalManager: GoalManager) {
        self.goal = goal
        self.goalManager = goalManager
        _progress = State(initialValue: goal.progress)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: goal.category.icon)
                                .font(.title)
                                .foregroundColor(goal.priority.color)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(goal.title)
                                    .font(.title)
                                    .bold()
                                
                                Text(goal.category.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        if !goal.description.isEmpty {
                            Text(goal.description)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Progress")
                            .font(.headline)
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("\(Int(progress * 100))%")
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                                
                                if goal.isCompleted {
                                    Label("Completed", systemImage: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            
                            Slider(value: $progress, in: 0...1, step: 0.01)
                                .accentColor(goal.priority.color)
                                .onChange(of: progress) { newValue in
                                    goalManager.updateProgress(for: goal.id, progress: newValue)
                                }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Complete Button
                    if !goal.isCompleted {
                        Button(action: {
                            goalManager.completeGoal(goal.id)
                            dismiss()
                        }) {
                            HStack {
                                Spacer()
                                Label("Mark as Complete", systemImage: "checkmark.circle.fill")
                                    .bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Goal Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct QuoteSheetView: View {
    @Binding var isPresented: Bool
    let quote: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Text("Stoic Guidance".localized)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 30)
                    
                    Text(quote)
                        .font(.title2)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Text("Reflect on how this applies to your current goals and challenges.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct WeeklyReviewView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var goalManager: GoalManager
    
    private let reviewQuestions = [
        "What did I accomplish this week that aligns with Stoic virtues?",
        "Where did I let external events disturb my inner peace?",
        "What am I most grateful for this week?",
        "What challenges did I face, and how did I respond?",
        "What can I improve for next week?",
        "Did I help others without expecting anything in return?",
        "What did I learn about myself this week?"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    Text("Weekly Stoic Review".localized)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 30)
                    
                    Text("Take time to reflect on your week through a Stoic lens.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    ForEach(Array(reviewQuestions.enumerated()), id: \.offset) { index, question in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(index + 1). \(question.localized)")
                                .font(.headline)
                            
                            TextField("Your reflection...", text: Binding(
                                get: { goalManager.weeklyReviewAnswers.indices.contains(index) ? goalManager.weeklyReviewAnswers[index] : "" },
                                set: { newValue in
                                    if goalManager.weeklyReviewAnswers.indices.contains(index) {
                                        goalManager.weeklyReviewAnswers[index] = newValue
                                        goalManager.saveWeeklyReviewAnswer(newValue, at: index)
                                    }
                                }
                            ), axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    Button("Complete Review") {
                        dismiss()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    GoalsView()
}
