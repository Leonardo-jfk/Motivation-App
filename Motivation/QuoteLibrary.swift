//
//  QuoteLibrary.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 28/10/2025.
//

//ATTENTION
//feature: make a star with every quote and the list of underlined quotes

import SwiftUI

// Shared quotes array accessible from any file in the app target.
// You can add more quotes here; keep them as comma-separated Swift string literals.

struct QuoteLibrary: View {
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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Quote Library".localized)
                .font(.largeTitle)
                .bold()
                .padding(30)
                .minimumScaleFactor(0.5)  // Allow text to shrink
                .lineLimit(1)
            
            HStack {
                // Favorites button
                Button(action: {
                    showFavorites.toggle()
                }, label: {
                    ZStack {
                        ButtonStyleSrt(.quoteLib)
                        Text("Favorites".localized)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                            .background(.gray.opacity(0.5))
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
        
            
//            List {
                // Determinar qué array de citas usar basado en el idioma
//                let quotes: [String] = {
//                    switch AppLanguage.houseSettingPage.l10n.currentLanguage {
//                    case .english:
//                        return quotesEng
//                    case .spanish:
//                        return quotesES
//                    }
//                }()
                
                List {
                    //                let quotes = AppLanguage.english ? quotesEng : quotesES
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
            }.onAppear {
                // Load notes when library opens so the sheet has the latest
                savedUserNotes = NotesStorage.load()
            }
            .onChange(of: savedUserNotes) { _, newValue in
                NotesStorage.save(newValue)
            }
            .onChange(of: favoriteQuotes) { _, newValue in FavoriteStorage.save(newValue)
            }
        }
        
        struct QuoteRow: View {
            let quote: String
            let isFavorite: Bool
            let toggleFavorite: () -> Void
            
            
            
            var body: some View {
                HStack {
                    Text(quote)
                        .padding(.vertical, 7)
                    Spacer()
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundStyle(isFavorite ? .red : .secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        
        // MARK: - Favorites list
        
    struct ChosenQuotesView: View {
        // Pass favorites in; you can use a binding if you need to mutate here too.
        //            var favoriteQuotes: Set<String>
        @Binding var favoriteQuotes: Set<String>
        var favoriteQuoteEnabled: Bool = UserDefaults.standard.bool(forKey: "favoriteQuoteEnabled")
        
//        @State private var showFavorites: Bool = false
//        
//        // Notes state owned here (in-memory). If you want persistence, we can switch later.
//        @State private var showUserNotes: Bool = false
//        @State private var savedUserNotes: Set<String> = []
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
                                    // Toggle favorite for this specific quote
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
    
        // MARK: - User notes
        
        struct UserNotesView: View {
            @Binding var savedUserNotes: Set<String>
            @State private var noteText: String = ""
            
            var body: some View {
                VStack(spacing: 16) {
                    HStack {
                        TextField("Write your note".localized, text: $noteText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .lineLimit(1...4)
                        Button("Add") {
                            let trimmed = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            savedUserNotes.insert(trimmed)
                            NotesStorage.save(savedUserNotes) // persist immediately
                            noteText = ""
                        }
                        .buttonStyle(.glassProminent)
                    }
                    .padding(.horizontal)
                    
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
                                // Support swipe-to-delete
                                let sorted = Array(savedUserNotes).sorted()
                                for index in indexSet {
                                    let toRemove = sorted[index]
                                    savedUserNotes.remove(toRemove)
                                }
                                NotesStorage.save(savedUserNotes) // persist deletion
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                .onAppear {
                    // Ensure binding is populated when the sheet opens
                    savedUserNotes = NotesStorage.load()
                }
            }
        }
        
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
                                // Support swipe-to-delete
                                let sorted = Array(savedUserNotes).sorted()
                                for index in indexSet {
                                    let toRemove = sorted[index]
                                    savedUserNotes.remove(toRemove)
                                }
                                NotesStorage.save(savedUserNotes) // persist deletion
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                .onAppear {
                    // Ensure binding is populated when the sheet opens
                    savedUserNotes = NotesStorage.load()
                }
            }
        }
        // MARK: - Simple persistence for notes
        
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
    }

//#Preview {
//    QuoteLibrary(favoriteQuotes: .constant(["gg"]))
//        .environmentObject(LocalizationManager.preview) // if it were an EnvironmentObject
//}
#Preview {
    QuoteLibrary(favoriteQuotes: .constant(["gg"]))
}
//fanally I got this shit working
////fanally I got this shit working
///IDK
