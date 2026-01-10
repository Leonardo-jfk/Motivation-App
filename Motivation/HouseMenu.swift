//
//  HouseMenu.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 16/12/2025.
//

import SwiftUI
import Lottie


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
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
//                    .padding(.horizontal, 20)
            case .houseMenuBack:
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(tileFillColor)
                    .frame(height: 350)
                    .frame(maxWidth: .infinity)
//                    .padding(.horizontal, 50)
                
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
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 70)
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
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColorScheme") private var storedScheme: String = AppColorScheme.system.rawValue
    private var appScheme: AppColorScheme {
        AppColorScheme(rawValue: storedScheme) ?? .system
    }
    
    var fileName1: String = "LightBackground"
    var fileName2: String = "DarkBackground"
    var fileName3: String = "MessageSent"
    var fileName4: String = "batman2"
    var fileName5: String = "batman"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .loop
    
    var onAnimationDidFinish: (() -> Void)? = nil
    
    
    @State private var selectedMenu: MenuOption = .none
    enum MenuOption {
        case none
        case personalNotes
        case mainSettings
        case resources
        case feedback
    }
    
    
    var body: some View {
        let lottieBackColor = (colorScheme == .dark) ? "DarkBackLottie" : "LightBackLottie"
        ZStack{
            
            LottieView(animation: .named(lottieBackColor))
                .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
                    lottieAnimationView.animationSpeed = 0.2
                })
                .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
                .animationDidFinish { completed in onAnimationDidFinish?()
                    
                }
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ZStack {
            VStack(alignment: .center, spacing: 20 ){
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
                                    selectedMenu = (selectedMenu == .personalNotes) ? .none : .personalNotes
                                }) {
                                    PersonalNotes(showing: selectedMenu == .personalNotes, savedUserNotes: $savedUserNotes)
                                }
                                .buttonStyle(.plain)
                                .simultaneousGesture(TapGesture().onEnded {
                                                    selectedMenu = .mainSettings
                                                })
                                
//                                Color.clear.frame(height: 10)
                                
                                Button(action: {
                                    selectedMenu = (selectedMenu == .mainSettings) ? .none : .mainSettings
                                }) {
                                    MainSettings(showing: selectedMenu == .mainSettings)
                                }
                                .buttonStyle(.plain)
                                .simultaneousGesture(TapGesture().onEnded {
                                                    selectedMenu = .mainSettings
                                                })
//                                Color.clear.frame(height: 10)
                                
                                Button(action: {
                                    selectedMenu = (selectedMenu == .resources) ? .none : .resources
                                }) {
                                    Resourses(showing: selectedMenu == .resources)
                                }
                                .buttonStyle(.plain)
                                
//                                Color.clear.frame(height: 10)
                                
                                Button(action: {
                                    selectedMenu = (selectedMenu == .feedback) ? .none : .feedback
                                }) {
                                    GetFeedback(showing: selectedMenu == .feedback)
                                }
                                .buttonStyle(.plain)
                                
//                                Color.clear.frame(height: 10)
                            }
                            .padding(.horizontal, 50)
                            .onAppear {
                                savedUserNotes = NotesStorage.load()
                            }
        }.padding(.horizontal, 50)
                    }
                }
}


struct PersonalNotes: View {
    let showing: Bool
    @Binding var savedUserNotes: Set<String>
    
    var body: some View {
        
        NavigationLink(destination: UserNotesView(savedUserNotes: $savedUserNotes)){
        ZStack {
                 // defaults to .houseMenu
            ButtonStyleSrt(.houseMenu)
                Text("Personal Notes ".localized)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                    .background(
                        Color.gray
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .opacity(0.5))
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
                    ButtonStyleSrt(.houseMenu)// defaults to .houseMenu
                    Text("Settings".localized)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .background(
                            Color.gray
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .opacity(0.5))
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
                        Text("The Sourse")
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
                                NavigationLink("Authors", destination: ResourcesIconsView())
                                    .foregroundStyle(.white)
                            }
                            Spacer()
//                            NavigationStack {
                                ZStack{
                                    ButtonStyleSrt(.stoicList)
                                    
                                    NavigationLink("Books", destination: ResourcesBookView())
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
                    ButtonStyleSrt(.houseMenu) // defaults to .houseMenu
                    Text("Best sourses of wisdom".localized)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.5))
                        .background(
                            Color.gray
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .opacity(0.5))
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
                        .background(
                            Color.gray
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .opacity(0.5))
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


