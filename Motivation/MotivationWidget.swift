//
//  MotivationWidget.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 25/07/2026.
//

import Foundation
import WidgetKit
import SwiftUI

// 1. Structure pour les données transmises au Widget
struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

// 2. Provider qui gère la mise à jour temporelle du Widget
struct Provider: TimelineProvider {
    
    // Citation par défaut si rien n'est encore enregistré
    let placeholderQuote = "Waste no more time arguing what a good man should be. Be one."

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: placeholderQuote)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), quote: fetchTodayQuote())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        let quote = fetchTodayQuote()
        let entry = SimpleEntry(date: currentDate, quote: quote)

        // Mettre à jour le widget le lendemain à minuit
        let nextUpdate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    // Lecture dans l'App Group
    private func fetchTodayQuote() -> String {
        let sharedDefaults = UserDefaults(suiteName: "group.com.tonnom.MotivationApp")
        return sharedDefaults?.string(forKey: "todayQuote") ?? placeholderQuote
    }
}

// 3. Vue SwiftUI du Widget
struct MotivationWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.yellow)
                Text("WISDOM")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(entry.quote)
                .font(.custom("CormorantGaramond-Italic", size: 16))
                .lineLimit(4)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color.black
        }
    }
}

// 4. Configuration principale du Widget
//@main
struct MotivationWidget: Widget {
    let kind: String = "MotivationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MotivationWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Citation du Jour")
        .description("Affiche votre dose quotidienne de sagesse stoïcienne.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
