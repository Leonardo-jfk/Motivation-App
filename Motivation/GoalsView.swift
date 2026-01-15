//
//  TrackView.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 06/01/2026.
//

import Foundation
import SwiftUI
import Lottie


public struct GoalsView: View {
    
    var fileName: String = "Girl with books"
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var playLoopMode: LottieLoopMode = .playOnce
    var onAnimationDidFinish: (() -> Void)? = nil
    
    public var body: some View {
        
//        ZStack{
//            LottieView(animation: .named("SciFiBack"))
//                .configure({lottieAnimationView in lottieAnimationView.contentMode = contentMode
//                 lottieAnimationView.animationSpeed = 0.2
//                })
//                
//                .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
//                .animationDidFinish { completed in onAnimationDidFinish?()
//                        
//                }
//                .resizable()
//                .ignoresSafeArea()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            
//            Rectangle()
//                .frame(width:300, height: 300)
//                .foregroundStyle(.white)
//         
//            VStack {
//                Text("goals List")
//                    .font(.largeTitle)
//                Image(systemName: "book").resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                // Your future challenges logic here
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
        
        Challenge9View()
    }
}
struct Challenge9View: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                // Contenido
                VStack(spacing: 25) {
                    Text(" Goal's creation")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "moon.stars")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Challenge Description")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Based on Stephen Covey's '7 Habits of Highly Effective People' - Begin with the End in Mind. Define your life's ultimate purpose and work backward to create meaningful goals.")
                            .foregroundColor(.white.opacity(0.9))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text("Daily Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("• What contributions do you want to be known for?")
                        Text("• List your 5 core non-negotiable values")
                        Text("• Where are you in 10 years if mission accomplished?")
                        Text("• Specific, measurable 1-year objectives")
                        Text("• Daily mission statement review")
                    }
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Botón de acción
                VStack(spacing: 15) {
                    Button(action: {
                        // Start challenge
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Mark as completed
                    }) {
                        Text("Mark as Completed")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    GoalsView()
}




//
//
//CHALLENGE: "BEGIN WITH THE END IN MIND"
//
//Challenge Description:
//
//"Based on Stephen Covey's '7 Habits of Highly Effective People' - Habit 2: Begin with the End in Mind. Define your life's ultimate purpose and work backward to create meaningful goals. Shift from reactive living to intentional creation by first clarifying what matters most, then building daily actions that align with your deepest values and desired legacy."
//
//30-Day Daily Tasks:
//
//Week 1: DEFINE YOUR ULTIMATE "END"
//
//Day 1-2: Funeral Visualization
//
//Write your ideal eulogy (3 versions: Family, Friends, Community)
//What do you want people to say about you?
//What character qualities do you want remembered?
//What contributions do you want to be known for?
//Day 3-4: 80th Birthday Speech
//
//Imagine your 80th birthday celebration
//What achievements would make you proud?
//What relationships would you cherish?
//What wisdom would you share?
//Day 5-7: Core Values Identification
//
//List your 5 core non-negotiable values
//Rank them in order of importance
//Write why each matters deeply to you
//Identify when you've lived these values recently
//Week 2: CREATE YOUR PERSONAL MISSION STATEMENT
//
//Day 8-10: Brainstorm Draft
//
//Start with "My life purpose is to..."
//Include roles (parent, professional, community member)
//Incorporate your core values
//Make it inspiring and personal
//Day 11-12: Refine & Polish
//
//Shorten to 1-2 powerful sentences
//Make it memorable and repeatable
//Ensure it guides daily decisions
//Test: Does this feel true when you read it?
//Day 13-14: Visualization & Internalization
//
//Read mission statement morning/night
//Create visual representation (vision board)
//Record yourself saying it
//Share with one trusted person
//Week 3: BACKWARD GOAL PLANNING
//
//Day 15-16: 10-Year Vision
//
//Where are you in 10 years if mission accomplished?
//Health, relationships, career, finances, personal growth
//Be specific but flexible on "how"
//Focus on being, not just having
//Day 17-19: 5-Year Milestones
//
//What must be true in 5 years to reach 10-year vision?
//Break into categories
//Identify key relationships to build
//Skills to develop
//Day 20-21: 1-Year Goals
//
//Specific, measurable 1-year objectives
//Aligned with 5-year milestones
//Focus on habits, not just outcomes
//Create quarterly review points
//Week 4: DAILY ALIGNMENT SYSTEM
//
//Day 22-24: Weekly Planning
//
//Each Sunday: Review mission statement
//Plan week's priorities using "Important/Urgent" matrix
//Schedule "big rocks" first (most important tasks)
//Ensure each week moves toward your "end"
//Day 25-27: Daily Decision Filter
//
//Morning: Read mission, ask "Does today's plan align?"
//Use "Will this matter in 5 years?" as decision filter
//Evening: Review alignment, adjust tomorrow
//Practice saying "no" to non-aligned opportunities
//Day 28-30: Integration & Adjustment
//
//Full system implementation
//Identify what's working/not working
//Adjust mission statement if needed
//Plan next quarter's focus
