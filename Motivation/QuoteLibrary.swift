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
    @State private var showFavorites: Bool = false

    // Notes state owned here (in-memory). If you want persistence, we can switch later.
    @State private var showUserNotes: Bool = false
    @State private var savedUserNotes: Set<String> = []

    var body: some View {
        VStack(alignment: .leading) {
            Text("Quote Library")
                .font(.largeTitle)
                .bold()
                .padding(20)

            HStack {
                // Favorites button
                Button(action: {
                    showFavorites.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 200, height: 60)
                        Text("Favorites")
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
                        ChosenQuotesView(favoriteQuotes: favoriteQuotes)
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
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 200, height: 60)
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

            List {
                ForEach(quotesEng, id: \.self) { quote in
                    HStack {
                        Text(quote)
                            .padding(.vertical, 7)
                        Spacer()
                        let isFavorite = favoriteQuotes.contains(quote)
                        Button {
                            if isFavorite {
                                favoriteQuotes.remove(quote)
                            } else {
                                favoriteQuotes.insert(quote)
                            }
                        } label: {
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
        }
    }
}

// MARK: - Favorites list

struct ChosenQuotesView: View {
    // Pass favorites in; you can use a binding if you need to mutate here too.
    let favoriteQuotes: Set<String>
    var favoriteQuoteEnabled: Bool = UserDefaults.standard.bool(forKey: "favoriteQuoteEnabled")

    var body: some View {
        VStack {
            if favoriteQuotes.isEmpty {
                Text("No favorites yet")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                List {
                    ForEach(Array(favoriteQuotes).sorted(), id: \.self) { quote in
                        Text(quote)
                            .padding(.vertical, 7)
                    }
                }
            }
        }
        .padding(.top)
    }
}

// MARK: - User notes

struct UserNotesView: View {
    @Binding var savedUserNotes: Set<String>
    @State private var noteText: String = ""

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                TextField("Write your note", text: $noteText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                Button("Add") {
                    let trimmed = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    savedUserNotes.insert(trimmed)
                    noteText = ""
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            Spacer()
            
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
                    }
                }
            }
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    // Preview with a constant binding for design-time
    QuoteLibrary(favoriteQuotes: .constant(["gg"]))
}
