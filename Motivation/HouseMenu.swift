//
//  HouseMenu.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 16/12/2025.
//

import SwiftUI

public enum ButtonShapeStyle {
    case quoteLib
    case houseMenu
    case houseMenuBack
    case stoicList
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
            
        case .stoicList:
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(tileFillColor)
                .frame(width: 100, height: 150)
        }
        }
    
}

//public var url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfspdMNWKv3vDnIB2WAuPbTMwECwIgIDgom0Dp9KNcuXFF-GQ/viewform?usp=dialog")

public let feedbackFormURL: URL = {
    guard let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfspdMNWKv3vDnIB2WAuPbTMwECwIgIDgom0Dp9KNcuXFF-GQ/viewform?usp=dialog") else {
        preconditionFailure("URL invalide: vérifiez la chaîne")
    }
    return url
}()

#if DEBUG
// Preview-safe lightweight fallback to ensure canvas can render even if
// runtime resources or future changes make the style heavy. This does not
// change runtime behavior; it only provides a simple shape for previews
// when compiled in DEBUG.
extension ButtonStyleSrt {
    @ViewBuilder
    public var previewBody: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.blue.opacity(0.4))
            .frame(width: 200, height: 60)
    }
}
#endif


// 2. Add author & book list views
struct StoicListView: View {
    var body: some View {
        List(stoicPhilosophers, id: \.name) { author in
            Link(author.name, destination: URL(string: author.url)!)
        }
        .navigationTitle("Stoic Authors")
    }
}

struct StoicBooksListView: View {
    var body: some View {
        List(stoicBooks, id: \.title) { book in
            VStack(alignment: .leading) {
                Link(book.title, destination: URL(string: book.url)!)
                Text(book.author).font(.subheadline).foregroundColor(.secondary)
            }
        }
        .navigationTitle("Stoic Books")
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
//            Color.clear.frame(height: 10)
            Spacer()
            Button(action: {
                showingPersonalNotes.toggle()
                // Close others
                showingMainSettings = false
                showingResourses = false
                showingFeedbackMenu = false
            }) {
                PersonalNotes(showing: showingPersonalNotes, savedUserNotes: $savedUserNotes)
            }
            .buttonStyle(.plain)
            
            Color.clear.frame(height: 10)

            Button(action: {
                showingMainSettings.toggle()
                // Close others
                showingPersonalNotes = false
                showingResourses = false
                showingFeedbackMenu = false
            }) {
                MainSettings(showing: showingMainSettings)
                
            }
            .buttonStyle(.plain)
            
            
            Color.clear.frame(height: 10)

            Button(action: {
                showingResourses.toggle()
                // Close others
                showingPersonalNotes = false
                showingMainSettings = false
                showingFeedbackMenu = false
            }) {
                Resourses(showing: showingResourses)
            }
            .buttonStyle(.plain)
                Color.clear.frame(height: 10)
           
            Button(action: {
                showingFeedbackMenu.toggle()
                // Close others
                showingPersonalNotes = false
                showingMainSettings = false
                showingResourses = false
            }) {
                GetFeedback(showing: showingFeedbackMenu)
            }
            .buttonStyle(.plain)
            
            Color.clear.frame(height: 10)
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
                    .bold()
                    .foregroundStyle(.white)
                    .background(.gray.opacity(0.5))
            }
            .padding()
        }
    }
}
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
                
//                NavigationStack{
                ZStack {
                    ButtonStyleSrt(.houseMenuBack)
                    NavigationStack {
                    VStack {
                        Text("Today's wisdom dose:".localized)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.gray.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .font(.title2)
                            .foregroundStyle(.white)
                        HStack{
                            Spacer()
                            ZStack{
                                ButtonStyleSrt(.stoicList)
                                NavigationLink("Authors", destination: ResourcesWisdomView())
                                    .foregroundStyle(.white)
                            }
                            Spacer()
//                            NavigationStack {
                                ZStack{
                                    ButtonStyleSrt(.stoicList)
                                    
                                    NavigationLink("Books", destination: StoicBooksListView())
                                        .foregroundStyle(.white)
                                }
                                Spacer()
//                            }
                        }
                        
                    }
//                    .padding()
                    }
//                .padding()
                
            }
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
//                        Text("The link:https://docs.google.com/forms/d/e/1FAIpQLSfspdMNWKv3vDnIB2WAuPbTMwECwIgIDgom0Dp9KNcuXFF-GQ/viewform?usp=dialog")
//                            .foregroundStyle(.white)
//                            .padding(.horizontal)
//                            .padding(.vertical)
                         
                            Link("See the quetionary", destination: feedbackFormURL)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(.gray.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        
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



#Preview {
    HouseMenu()
}

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


