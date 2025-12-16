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
    @State private var showingFeedbackMenu = false



    var body: some View {
        VStack(alignment: .leading) {
        
                   Text("MENU")
                    .font(.largeTitle)
                    .bold()
                    .padding(20)
                    .background(
                        Color.gray
                            .clipShape(RoundedRectangle(cornerRadius: 20)))
                    Spacer()
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

struct GetFeedback: View {
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

                Text("Get today's wisdom ")
                    .font(.title3)
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
    GetFeedback(showing: true)
}
