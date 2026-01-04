//
//  QuoteLibrary.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 28/10/2025.
//

//ATTENTION
//feature: make a star with every quote and the list of underlined quotes

import SwiftUI
import Lottie

// Shared quotes array accessible from any file in the app target.
// You can add more quotes here; keep them as comma-separated Swift string literals.

public struct QuoteLibrary: View {
    // Binding source of truth is provided by a parent view.
    @Binding var favoriteQuotes: Set<String>
    @State public var showFavorites: Bool = false
    
    // Notes state owned here (in-memory). If you want persistence, we can switch later.
    @State private var showUserNotes: Bool = false
    @State private var savedUserNotes: Set<String> = []
    @StateObject private var l10n = LocalizationManager.shared
    
    private var currentQuotes: [String] {
        switch l10n.currentLanguage {
        case .english:
            return quotesEng
        case .spanish:
            return quotesES
        case .french:
            return quotesFR
        }
        
    }
    
        public var body: some View {
            VStack(alignment: .leading) {
                Text("Quote Library".localized)
                    .font(.largeTitle)
                    .bold()
                    .padding(30)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                HStack {
                        Button(action: {
                            showFavorites.toggle()
                        }, label: {
                            ZStack {
                                ButtonStyleSrt(.quoteLib)
                                    .frame(maxWidth: .infinity)
                                Text("Favorites".localized)
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .background(.gray.opacity(0.5))
                                    .minimumScaleFactor(0.5)  // Allow text to shrink
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 4)
                        })
                        .buttonStyle(.plain)
                        .sheet(isPresented: $showFavorites) {
                            NavigationStack {
                                ChosenQuotesView(favoriteQuotes: $favoriteQuotes)
                                    .navigationTitle("Favorites")
                                    .navigationBarTitleDisplayMode(.inline)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarTrailing) {
                                            Button("Done") { showFavorites = false }
                                        }
                                    }
                            }
                        }
        
                        // Your own ideas button
                        Button(action: {
                            showUserNotes.toggle()
                        }, label: {
                            ZStack {
                                ButtonStyleSrt(.quoteLib)
                                Text("Your own ideas")
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .background(.gray.opacity(0.5))
                                    .minimumScaleFactor(0.5)  // Allow text to shrink
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 4)
                        })
                        .buttonStyle(.plain)
                        .sheet(isPresented: $showUserNotes) {
                            NavigationStack {
                                UserNotesView(savedUserNotes: $savedUserNotes)
                                    .navigationTitle("Your Notes")
                                    .navigationBarTitleDisplayMode(.inline)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarTrailing) {
                                            Button("Done") { showUserNotes = false }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 4)

                    
                    
                    
                }
                .padding(.horizontal, 10)
                
                List {
                    ForEach(currentQuotes, id: \.self) { quote in
                        QuoteRow(quote: quote, isFavorite: favoriteQuotes.contains(quote)) {
                            if favoriteQuotes.contains(quote) {
                                favoriteQuotes.remove(quote)
                            } else {
                                favoriteQuotes.insert(quote)
                            }
                            FavoriteStorage.save(favoriteQuotes)
                        }
                    }
                }
            }
            .onAppear {
                savedUserNotes = NotesStorage.load()
            }
            .onChange(of: savedUserNotes) { _, newValue in
                NotesStorage.save(newValue)
            }
            .onChange(of: favoriteQuotes) { _, newValue in
                FavoriteStorage.save(newValue)
            }
        }
    }

    // Move QuoteRow outside of QuoteLibrary struct
    struct QuoteRow: View {
        let quote: String
        let isFavorite: Bool
        let toggleFavorite: () -> Void
        
        @State private var lottieAnimationButton = false
        var fileName3: String = "MessageSent"
        var contentMode: UIView.ContentMode = .scaleAspectFill
        var playLoopMode: LottieLoopMode = .playOnce
        var onAnimationDidFinish: (() -> Void)? = nil
        
        var body: some View {
            ZStack{
                HStack {
                    Text(quote)
                        .padding(.vertical, 7)
                    Spacer()
                    Button(action: {
                        triggerAnimation()
                        toggleFavorite() })
                    {
                       
                    
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundStyle(isFavorite ? .red : .secondary)
                    }
                    .buttonStyle(.plain)
                }
                if lottieAnimationButton {
                    LottieView(animation: .named(fileName3))
                        .configure { lottieAnimationView in lottieAnimationView.contentMode = contentMode }
                        .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
//                        .animationDidFinish { completed in onAnimationDidFinish?() }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .transition(.scale.combined(with: .opacity))
//                        .zIndex(1)
                }
                
            }
        }
        
        // Helper to keep the button actions clean
            private func triggerAnimation() {
                withAnimation(.spring()) {
                    lottieAnimationButton = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Reduced to 2s for better UX
                    lottieAnimationButton = false
                }
            }
    }

    // Move ChosenQuotesView outside of QuoteLibrary struct
    struct ChosenQuotesView: View {
        @Binding var favoriteQuotes: Set<String>
        var favoriteQuoteEnabled: Bool = UserDefaults.standard.bool(forKey: "favoriteQuoteEnabled")
        @StateObject private var l10n = LocalizationManager.shared
        
        var body: some View {
            VStack {
                if favoriteQuotes.isEmpty {
                    Text("No favorites yet".localized)
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(Array(favoriteQuotes).sorted(), id: \.self) { quote in
                            HStack {
                                Text(quote)
                                    .padding(.vertical, 7)
                                Spacer()
                                Button(action: {
                                    if favoriteQuotes.contains(quote) {
                                        favoriteQuotes.remove(quote)
                                    } else {
                                        favoriteQuotes.insert(quote)
                                    }
                                    
                                    FavoriteStorage.save(favoriteQuotes)
                                
                                    
                                    
                                }) {
                                    Image(systemName: favoriteQuotes.contains(quote) ? "heart.fill" : "heart")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                        .foregroundStyle(favoriteQuotes.contains(quote) ? .red : .secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
        }
    }

    // Move UserNotesView outside of QuoteLibrary struct
    public struct UserNotesView: View {
        @Binding var savedUserNotes: Set<String>
        @State private var noteText: String = ""
        @State private var lottieAnimationButton = false
        
        var fileName5: String = "Menorah"
        var contentMode: UIView.ContentMode = .scaleAspectFill
        var playLoopMode: LottieLoopMode = .playOnce
        var onAnimationDidFinish: (() -> Void)? = nil
        
        public var body: some View {
            ZStack {
                VStack(spacing: 16) {
                    HStack {
                        TextField("Write your note".localized, text: $noteText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .lineLimit(1...4)
                        Button("Add") {
                            let trimmed = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            
                            withAnimation(.spring()) {
                                savedUserNotes.insert(trimmed)
                                lottieAnimationButton = true
                            }
                            NotesStorage.save(savedUserNotes)
                            noteText = ""
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                lottieAnimationButton = false
                            }
                        }
                        .buttonStyle(.glassProminent)
                    }
                    
                    Spacer()
                    
                    if savedUserNotes.isEmpty {
                        Text("No notes yet".localized)
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        List {
                            ForEach(Array(savedUserNotes).sorted(), id: \.self) { note in
                                Text(note)
                                    .padding(.vertical, 7)
                            }
                            .onDelete { indexSet in
                                let sorted = Array(savedUserNotes).sorted()
                                for index in indexSet {
                                    let toRemove = sorted[index]
                                    savedUserNotes.remove(toRemove)
                                }
                                NotesStorage.save(savedUserNotes)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                if lottieAnimationButton {
                    LottieView(animation: .named(fileName5))
                        .configure { lottieAnimationView in lottieAnimationView.contentMode = contentMode }
                        .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
                        .animationDidFinish { completed in onAnimationDidFinish?() }
    //                    .zIndex(1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Top left
                        .padding(.horizontal)
                }
                
            }
            .onAppear {
                savedUserNotes = NotesStorage.load()
            }
          
        }
    }

    // Move QuickNotesView outside
    struct QuickNotesView: View {
        @Binding var savedUserNotes: Set<String>
        @State private var noteText: String = ""
        
        var body: some View {
            VStack(spacing: 16) {
                if savedUserNotes.isEmpty {
                    Text("No notes yet")
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(Array(savedUserNotes).sorted(), id: \.self) { note in
                            Text(note)
                                .padding(.vertical, 7)
                        }
                        .onDelete { indexSet in
                            let sorted = Array(savedUserNotes).sorted()
                            for index in indexSet {
                                let toRemove = sorted[index]
                                savedUserNotes.remove(toRemove)
                            }
                            NotesStorage.save(savedUserNotes)
                        }
                    }
                }
                Spacer()
            }
            .padding(.top)
            .onAppear {
                savedUserNotes = NotesStorage.load()
            }
        }
    }


public enum NotesStorage {
    private static let key = "userNotes"
    static func load() -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        if let decoded = try? JSONDecoder().decode([String].self, from: data) {
            return Set(decoded)
        }
        return []
    }
    static func save(_ notes: Set<String>) {
        let array = Array(notes)
        if let data = try? JSONEncoder().encode(array) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

public enum FavoriteStorage {
    private static let key = "favoriteQuotes"
    static func load() -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        if let decoded = try? JSONDecoder().decode([String].self, from: data) {
            return Set(decoded)
        }
        return []
    }
    static func save(_ quotes: Set<String>) {
        let array = Array(quotes)
        if let data = try? JSONEncoder().encode(array) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}


#Preview {
    QuoteLibrary(favoriteQuotes: .constant(["gg"]))
}
