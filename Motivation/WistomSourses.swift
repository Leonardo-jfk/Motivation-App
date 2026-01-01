//
//  WistomSourses.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 01/01/2026.
//
import SwiftUI


let stoicPhilosophers: [(photo: String ,name: String, role: String, url: String)] = [
    ("MarcoPhoto", "Marcus Aurelius", "Roman Emperor, author of Meditations", "https://en.wikipedia.org/wiki/Marcus_Aurelius"),
    ("ArnoldPhoto","Arnold Schwarzenegger", "Admirateur moderne du stoïcisme", "https://en.wikipedia.org/wiki/Arnold_Schwarzenegger"),
    ("SenecaPhoto.jpg","Seneca", "Roman philosopher, statesman, and playwright", "https://en.wikipedia.org/wiki/Seneca_the_Younger"),
    ("EpictetusPhoto.jpg","Epictetus", "Greek philosopher, former slave", "https://en.wikipedia.org/wiki/Epictetus"),
    ("ZenonPhoto.jpg","Zeno of Citium", "Founder of Stoicism", "https://en.wikipedia.org/wiki/Zeno_of_Citium"),
    ("CleanthesPhoto.jpg","Cleanthes", "Successor to Zeno", "https://en.wikipedia.org/wiki/Cleanthes"),
    ("MusoniusPhoto.jpg","Musonius Rufus", "Teacher of Epictetus", "https://en.wikipedia.org/wiki/Gaius_Musonius_Rufus"),
    ("ChrysipposPhoto.jpg","Chrysippus", "Systematizer of Stoicism", "https://en.wikipedia.org/wiki/Chrysippus"),
    ("CatoPhoto.jpg","Cato the Younger", "Roman senator and Stoic practitioner", "https://en.wikipedia.org/wiki/Cato_the_Younger"),
    ("HieroclesPhoto.jpg","Hierocles", "Stoic philosopher known for circles of concern", "https://en.wikipedia.org/wiki/Hierocles_(Stoic)"),
    ("PosidonioPhoto.jpg","Posidonius", "Influential Stoic polymath", "https://en.wikipedia.org/wiki/Posidonius"),
    ("StockdalePhoto.jpg","James Stockdale", "Amiral américain, appliqua le stoïcisme en captivité", "https://en.wikipedia.org/wiki/James_Stockdale")
]




let stoicBooks: [(title: String, author: String, type: String, url: String)] = [
    ("Meditations", "Marcus Aurelius", "Philosophical journal", "https://en.wikipedia.org/wiki/Meditations"),
    ("Letters from a Stoic", "Seneca", "Philosophical letters", "https://en.wikipedia.org/wiki/Epistulae_Morales_ad_Lucilium"),
    ("Enchiridion", "Epictetus", "Handbook", "https://en.wikipedia.org/wiki/Enchiridion_of_Epictetus"),
    ("Discourses", "Epictetus", "Lectures and dialogues", "https://en.wikipedia.org/wiki/Discourses_of_Epictetus"),
    ("On the Shortness of Life", "Seneca", "Essay", "https://en.wikipedia.org/wiki/De_Brevitate_Vitae_(Seneca)"),
    ("On Anger", "Seneca", "Treatise on emotions", "https://en.wikipedia.org/wiki/De_Ira"),
    ("On the Happy Life", "Seneca", "Ethical essay", "https://en.wikipedia.org/wiki/De_Vita_Beata"),
    ("Hymn to Zeus", "Cleanthes", "Philosophical poem", "https://en.wikipedia.org/wiki/Hymn_to_Zeus"),
    ("A Guide to the Good Life", "William B. Irvine", "Modern introduction", "https://en.wikipedia.org/wiki/William_B._Irvine"),
    ("The Obstacle Is the Way", "Ryan Holiday", "Applied stoicism", "https://en.wikipedia.org/wiki/Ryan_Holiday")
]

public struct ResourcesWisdomView: View {
    let philosophers = stoicPhilosophers
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Stoic Philosophers")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                ForEach(philosophers, id: \.name) { philosopher in
                    HStack(spacing: 15) {
                        // Try using Asset catalog image
                        if let uiImage = UIImage(named: philosopher.photo) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            // Fallback if image doesn't exist
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text(String(philosopher.name.prefix(1)))
                                        .font(.title)
                                        .bold()
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(philosopher.name)
                                .font(.headline)
                            
                            Text(philosopher.role)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Link("Learn more", destination: URL(string: philosopher.url)!)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
