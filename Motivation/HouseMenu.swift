//
//  HouseMenu.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 16/12/2025.
//

//
//  houseMenu.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 16/12/2025.
//
import SwiftUI

struct HouseMenu: View {
    
    @State private var showingPersonalNotes = false
    @State private var showingMainSettings = false
    @State private var showingResourses = false
    @State private var showingFeedbackMenu = false



    var body: some View {
        //VStack(alignment: .leading) {
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
                PersonalNotes(showing: showingPersonalNotes)
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
    }
}

struct PersonalNotes: View {
    let showing: Bool
   

    var body: some View {
        if showing {
            ZStack {
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 350, height: 350)

                VStack {
                    Text("Feedback")
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
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 200, height: 100)

                Text("Personal Notes ")
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
        if showing {
            NavigationStack{
                NavigationLink(destination: SettingsList())
                {
                    
                }}}
        else {
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 200, height: 100)
                
                Text("Settings ")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                    .background(.gray.opacity(0.5))
            }
            .padding()
        }}}
            //            ZStack {
            //                RoundedRectangle(cornerRadius: 40, style: .continuous)
            //                    .fill(Color.black.opacity(0.8))
            //                    .frame(width: 350, height: 350)
            //
            //                VStack {
            //                    Text("Today's wisdom dose:")
            //                        .padding(.horizontal, 8)
            //                        .padding(.vertical, 4)
            //                        .background(.gray.opacity(0.4))
            //                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            //                        .font(.title2)
            //                        .foregroundStyle(.white)
            //
            //
            //                }
            //                .padding()
            //            }
            //            .padding()
            //        } else {
            //            ZStack {
            //                RoundedRectangle(cornerRadius: 30, style: .continuous)
            //                    .fill(Color.black.opacity(0.8))
            //                    .frame(width: 200, height: 100)
            //
            //                Text("Settings ")
            //                    .font(.title2)
            //                    .bold()
            //                    .foregroundStyle(.white)
            //                    .background(.gray.opacity(0.5))
            //            }
            //            .padding()
            //        }
            //    }
            //}
            
struct Resourses: View {
                let showing: Bool
                
                
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
                                
                                
                            }
                            .padding()
                        }
                        .padding()
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Color.black.opacity(0.8))
                                .frame(width: 200, height: 100)
                            
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
                            RoundedRectangle(cornerRadius: 40, style: .continuous)
                                .fill(Color.black.opacity(0.8))
                                .frame(width: 350, height: 350)
                            
                            VStack {
                                Text("How to give us feedback:")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.gray.opacity(0.4))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                
                                Text("Open the link to the Google Form and answer the questions")
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
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Color.black.opacity(0.8))
                                .frame(width: 200, height: 100)
                            
                            Text("Give us feedback ")
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

#Preview {
    PersonalNotes(showing: true)
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
