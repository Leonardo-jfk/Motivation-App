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
    @State var showFavorites: Bool = false
    
    var body: some View {
//        NavigationStack{
        VStack(alignment: .leading) {
            Text("Quote Library")
                .font(.largeTitle)
                .bold()
                .padding(20)
            HStack{
            // Button to open favorites list (as a sheet)
//                Spacer(minLength: 16)
                
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
                Button(action: {
                    showFavorites.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 200, height: 60)
//                            .padding(.horizontal, 20)
                        
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
                        userNotesView(savedUserNotes:  savedUserNotes)
                            .navigationTitle("Favorites")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Done") { showFavorites = false }
                                }
                            }
                    }
                }.padding(.horizontal, 4)
//                Spacer(minLength: 16)
        }.padding(.horizontal, 10)
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
//}

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
                    // Convert Set to Array for deterministic order (optional: .sorted())
                    ForEach(Array(favoriteQuotes), id: \.self) { quote in
                        Text(quote)
                            .padding(.vertical, 7)
                    }
                }
            }
        }
        .padding(.top)
        
    }
}



struct userNotesView: View {
    
    @State var showUserNotes:Bool = false
    @State var savedUserNotes: Set<String> = []ç
    
    var body: some View {
        VStack {
            TextField("Write your note", text: $savedUserNotes)
                .keyboardType(.emailAddress)
                               .padding(16)
                               .background(.gray.opacity(0.2))
                               .cornerRadius(16)
                               .padding(.horizontal, 32)
                               .onChange(of: userNotes) { oldValue, newValue in
                                   print("El antiguo valor era \(oldValue) y el nuevo es \(newValue)")
            if showUserNotes.isEmpty {
                Text("No notes yet")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                
                List {
                    // Convert Set to Array for deterministic order (optional: .sorted())
                    ForEach(Array(showUserNotes), id: \.self) { quote in
                        Text(showUserNotes)
                            .padding(.vertical, 7)
                    }
                }
            }
        }
        .padding(.top)
        
    }
    }
    
}

#Preview {
    // Preview with a constant binding for design-time
    QuoteLibrary(favoriteQuotes: .constant(["gg"]))
}
