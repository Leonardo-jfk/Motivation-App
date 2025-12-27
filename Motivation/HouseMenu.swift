//
<<<<<<< Updated upstream
//  HouseMenu.swift
=======
//  houseMenu.swift
>>>>>>> Stashed changes
//  Motivation
//
//  Created by Leonardo Aurelio on 16/12/2025.
//
<<<<<<< Updated upstream

import SwiftUI

public enum ButtonShapeStyle {
    case quoteLib
    case houseMenu
    case houseMenuBack
}

public struct ButtonStyleSrt: View {
    @Environment(\.colorScheme) var colorScheme
    var tileFillColor: Color { colorScheme == .light ? Color.black.opacity(0.8)  : Color.gray.opacity(0.6) }
    
    private let style: ButtonShapeStyle
    
    // Default initializer to keep existing call sites working (e.g., ButtonStyleSrt())
    public init() {
        self.style = .houseMenu
    }
    
    // New initializer that accepts a specific style
    public init(_ style: ButtonShapeStyle) {
        self.style = style
    }
    
    public var body: some View {
        switch style {
        case .quoteLib:
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(tileFillColor)
                .frame(width: 200, height: 60)
        case .houseMenu:
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(tileFillColor)
                .frame(width: 200, height: 100)
        case .houseMenuBack:
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(tileFillColor)
                .frame(width: 350, height: 350)
        }
    }
}

struct HouseMenu: View {
    
    @State private var showingPersonalNotes = false
    @State private var showingMainSettings = false
    @State private var showingResourses = false
    @State private var showingFeedbackMenu = false
    
    @State private var savedUserNotes: Set<String> = []
    
    var body: some View {
        VStack{
            Text("MENU")
                .font(.largeTitle)
                .bold()
                .padding(20)
            
                .frame(maxWidth: 150)
                .background(
                    Color.gray
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .opacity(0.6))
            Spacer()
            
            Button(action: {
                showingPersonalNotes.toggle()
            }) {
                PersonalNotes(showing: showingPersonalNotes, savedUserNotes: $savedUserNotes)
            }
            .buttonStyle(.plain)
            
            
            Button(action: {
                showingMainSettings.toggle()
            }) {
                MainSettings(showing: showingMainSettings)
                
            }
            .buttonStyle(.plain)
            
            
            
            Button(action: {
                showingResourses.toggle()
            }) {
                Resourses(showing: showingResourses)
            }
            .buttonStyle(.plain)
            
            
            Button(action: {
                showingFeedbackMenu.toggle()
            }) {
                GetFeedback(showing: showingFeedbackMenu)
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear{
            savedUserNotes = QuoteLibrary.NotesStorage.load()
        }
    }
}

struct UserNotesViewWrapper: View {
    @Binding var savedUserNotes: Set<String>
    
    var body: some View {
        QuoteLibrary.UserNotesView(savedUserNotes: $savedUserNotes)
    }
}

struct PersonalNotes: View {
    let showing: Bool
    @Binding var savedUserNotes: Set<String>
    
    var body: some View {
        
        ZStack {
            ButtonStyleSrt()
            NavigationLink(destination: UserNotesViewWrapper(savedUserNotes: $savedUserNotes)){
                 // defaults to .houseMenu
                Text("Personal Notes ".localized)
                    .font(.title2)
=======
import SwiftUI

struct HouseMenu: View {
    @State private var showingFeedbackMenu = false

    // Reuse the same “todayIndex” logic you used in ContentView
    private var todayIndex: Int {
        let calendar = Calendar.current
        let day = calendar.ordinality(of: .day, in: .year, for: .now) ?? 1
        guard !quotes.isEmpty else { return 0 }
        return (day - 1) % quotes.count
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Quote Library")
                .font(.largeTitle)
                .bold()
                .padding(20)

            Button(action: {
                showingFeedbackMenu.toggle()
            }) {
                GetFeedback(showing: showingFeedbackMenu, todayIndex: todayIndex)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal)
    }
}

struct GetFeedback: View {
    let showing: Bool
    let todayIndex: Int

    var body: some View {
        if showing {
            ZStack {
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 350, height: 350)

                VStack {
                    Text("Today's wisdom dose:")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.gray.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .font(.title2)
                        .foregroundStyle(.white)

                    DayQuoteView(index: todayIndex)
                        .padding(.horizontal)
                        .frame(maxWidth: 350, maxHeight: 300)
                }
                .padding()
            }
            .padding()
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 200, height: 100)

                Text("Get today's wisdom ")
                    .font(.title3)
>>>>>>> Stashed changes
                    .bold()
                    .foregroundStyle(.white)
                    .background(.gray.opacity(0.5))
            }
            .padding()
        }
    }
}
<<<<<<< Updated upstream
    struct MainSettings: View {
        let showing: Bool
        
        var body: some View {
            NavigationLink(destination: SettingsList())
            {
                ZStack {
                    ButtonStyleSrt() // defaults to .houseMenu
                    Text("Settings ".localized)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.5))
                }
            }
        }
    }
    
    struct Resourses: View {
        let showing: Bool
        
        var body: some View {
            if showing {
                ZStack {
                    ButtonStyleSrt(.houseMenuBack)
                    VStack {
                        Text("Today's wisdom dose:".localized)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.gray.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                    .padding()
                }
                .padding()
            } else {
                ZStack {
                    ButtonStyleSrt() // defaults to .houseMenu
                    Text("Best sourses of wisdom ")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.5))
                }
                .padding()
            }
        }
    }
    
    struct GetFeedback: View {
        let showing: Bool
        
        var body: some View {
            if showing {
                ZStack {
                    ButtonStyleSrt(.houseMenuBack)
                    
                    VStack {
                        Text("How to give us feedback:".localized)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.gray.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .font(.title2)
                            .foregroundStyle(.white)
                        
                        Text("Open the link to the Google Form and answer the questions".localized)
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical)
                        Text("The link:https://docs.google.com/forms/d/e/1FAIpQLSfspdMNWKv3vDnIB2WAuPbTMwECwIgIDgom0Dp9KNcuXFF-GQ/viewform?usp=dialog")
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical)
                    }
                    .padding()
                }
                .padding()
            } else {
                ZStack {
                    ButtonStyleSrt() // defaults to .houseMenu
                    Text("Give us feedback ".localized)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.5))
                }
                .padding()
            }
        }
    }



=======
>>>>>>> Stashed changes

#Preview {
    HouseMenu()
}

<<<<<<< Updated upstream
#Preview("Personal Notes - showing") {
    PersonalNotes(showing: true, savedUserNotes: .constant(["test"]))
}
#Preview("Personal Notes - Hidden") {
    PersonalNotes(showing: false, savedUserNotes: .constant([]))
}
#Preview {
    MainSettings(showing: true)
}
#Preview {
    Resourses(showing: true)
}
#Preview {
    GetFeedback(showing: true)
}

=======
#Preview {
    GetFeedback(showing: true, todayIndex: 0)
}
>>>>>>> Stashed changes
