//
//  QuoteLibrary.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 28/10/2025.
//

import SwiftUI

// Shared quotes array accessible from any file in the app target.
let quotes: [String] = [
    "You have power over your mind — not outside events. — Marcus Aurelius",
    "Waste no more time arguing what a good man should be. Be one. — Marcus Aurelius",
    "The best revenge is not to be like your enemy. — Marcus Aurelius",
    "Very little is needed to make a happy life. — Marcus Aurelius",
    "Accept whatever comes to you woven in the pattern of your destiny. — Marcus Aurelius",
    "The soul becomes dyed with the colour of its thoughts. — Marcus Aurelius",
    "Everything we hear is an opinion, not a fact. — Marcus Aurelius",
    "Nowhere can man find a quieter retreat than in his own soul. — Marcus Aurelius",
    "Life is short — the fruit of this life is a good character. — Marcus Aurelius",
    "Be tolerant with others and strict with yourself. — Marcus Aurelius",
    "The universe is change; our life is what our thoughts make it. — Marcus Aurelius",
    "Look well into thyself; there is a source of strength. — Marcus Aurelius",
    "Nothing happens to anyone that they can’t endure. — Marcus Aurelius",
    "The first rule is to keep an untroubled spirit. — Marcus Aurelius",
    "Do every act of your life as if it were your last. — Marcus Aurelius",
    "If it is not right, do not do it. If it is not true, do not say it. — Marcus Aurelius",
    "Now is the time to learn truly who you are. — Marcus Aurelius",
    "Let men see, let them know, a real man. — Marcus Aurelius",
    "You are a little soul carrying around a corpse. — Epictetus",
    "Don’t explain your philosophy. Embody it. — Epictetus",
    "Wealth consists not in having great possessions, but in having few wants. — Epictetus",
    "First say to yourself what you would be; and then do what you have to do. — Epictetus",
    "No man is free who is not master of himself. — Epictetus",
    "Circumstances don’t make the man, they only reveal him. — Epictetus",
    "It’s not what happens to you, but how you react that matters. — Epictetus",
    "Only the educated are free. — Epictetus",
    "If you want to improve, be content to be thought foolish. — Epictetus",
    "He who laughs at himself never runs out of things to laugh at. — Epictetus",
    "Freedom is the only worthy goal in life. — Epictetus",
    "Attach yourself to what is spiritually superior. — Epictetus",
    "Practice yourself, for heaven’s sake, in little things. — Epictetus",
    "We suffer more often in imagination than in reality. — Seneca",
    "Luck is what happens when preparation meets opportunity. — Seneca",
    "It is not that we have a short time to live, but that we waste a lot of it. — Seneca"
]

// Optional: a simple browser for all quotes, using the shared array above.
struct QuoteLibrary: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Quote Library")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)

            List {
                ForEach(quotes, id: \.self) { quote in
                    Text(quote)
                        .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

#Preview {
    QuoteLibrary()
}
