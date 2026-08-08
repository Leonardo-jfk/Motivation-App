////
////  WidgetMotivation.swift
////  WidgetMotivation
////
////  Created by Leonardo Aurelio on 25/07/2026.
////
//
//import WidgetKit
//import SwiftUI
//
//struct Provider: AppIntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
//    }
//
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: configuration)
//    }
//    
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        return Timeline(entries: entries, policy: .atEnd)
//    }
//
////    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
////        // Generate a list containing the contexts this widget is relevant in.
////    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationAppIntent
//}
//
//struct WidgetMotivationEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Favorite Emoji:")
//            Text(entry.configuration.favoriteEmoji)
//        }
//    }
//}
//
//struct WidgetMotivation: Widget {
//    let kind: String = "WidgetMotivation"
//
//    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            WidgetMotivationEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//    }
//}
//
//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}
//
//#Preview(as: .systemSmall) {
//    WidgetMotivation()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}








//
//import Foundation
//import WidgetKit
//import SwiftUI
//
//// 1. Structure pour les données transmises au Widget
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let quote: String
//}
//
//// 2. Provider qui gère la mise à jour temporelle du Widget
//struct Provider: TimelineProvider {
//    
//    // Citation par défaut si rien n'est encore enregistré
//    let placeholderQuote = "Waste no more time arguing what a good man should be. Be one."
//
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), quote: placeholderQuote)
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), quote: fetchTodayQuote())
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
//        let currentDate = Date()
//        let quote = fetchTodayQuote()
//        let entry = SimpleEntry(date: currentDate, quote: quote)
//
//        // Mettre à jour le widget le lendemain à minuit
//        let nextUpdate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!)
//        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
//        
//        completion(timeline)
//    }
//    
//    // Lecture dans l'App Group
//    private func fetchTodayQuote() -> String {
//        let sharedDefaults = UserDefaults(suiteName: "group.com.tonnom.MotivationApp")
//        return sharedDefaults?.string(forKey: "todayQuote") ?? placeholderQuote
//    }
//}
//
//// 3. Vue SwiftUI du Widget
//struct MotivationWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image("arnoldPhoto")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(minWidth: 45, idealWidth: 75, maxWidth: 100, minHeight: 45, idealHeight: 75, maxHeight: 100, alignment: .topLeading)
////                    .frame(width: 45, height: 45)
//                    .clipShape(Circle())
//                Text("WISDOM")
//                    .font(.caption)
//                    .fontWeight(.bold)
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//            
//            Text(entry.quote)
//                .font(.custom("CormorantGaramond-Italic", size: 16))
////                .foregroundStyle(.secondary.opacity(100))
//                .foregroundColor(.gray)
//                .lineLimit(4)
//                .minimumScaleFactor(0.8)
//                .multilineTextAlignment(.leading)
//            
//            Spacer()
//        }
//        .padding()
//        .containerBackground(for: .widget) {
//            Color.black
//        }
//    }
//}
//
//// 4. Configuration principale du Widget
////@main
//struct WidgetMotivation: Widget {
//    let kind: String = "MotivationWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            MotivationWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("Citation du Jour")
//        .description("Affiche votre dose quotidienne de sagesse stoïcienne.")
//        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
//    }
//}




import Foundation
import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

struct Provider: TimelineProvider {
    
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

        let nextUpdate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    // Correction ici : Utilisation du bon ID de groupe ("group.Leonardo.Motivation")
    private func fetchTodayQuote() -> String {
        let sharedDefaults = UserDefaults(suiteName: "group.Leonardo.Motivation")
        return sharedDefaults?.string(forKey: "todayQuote") ?? placeholderQuote
    }
}


func authorPhotoName(for quote: String) -> String {
    let lower = quote.lowercased()
    
    if lower.contains("épictète") || lower.contains("epictetus") {
        return "EpictetusPhoto"
    } else if lower.contains("marc") || lower.contains("aurelius") || lower.contains("marco") {
        return "MarcoPhoto"
    } else if lower.contains("sénèque") || lower.contains("seneca") {
        return "SenecaPhoto"
    } else if lower.contains("caton") || lower.contains("cato") {
        return "CatoPhoto"
    } else if lower.contains("zénon") || lower.contains("zeno") || lower.contains("zenon") {
        return "ZenonPhoto"
    } else if lower.contains("chrysippus") || lower.contains("chrysippe") || lower.contains("chrysippos") {
        return "ChrysipposPhoto"
    } else if lower.contains("cléanthe") || lower.contains("cleanthes") {
        return "CleanthesPhoto"
    } else if lower.contains("hiéroclès") || lower.contains("hierocles") {
        return "HieroclesPhoto"
    } else if lower.contains("musonius") {
        return "MusoniusPhoto"
    } else if lower.contains("posidonios") || lower.contains("posidonio") {
        return "PosidonioPhoto"
    } else if lower.contains("stockdale") {
        return "StockdalePhoto"
    } else if lower.contains("zeus") {
        return "ZeusPhoto"
    }
    
    // Photo par défaut si aucun auteur correspondant n'est trouvé
    return "arnoldPhoto"
}

//struct MotivationWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
////                Image("arnoldPhoto")
//                Image(authorPhotoName(for: entry.quote))
//                    .resizable()
//                    .scaledToFit()
//                    .frame(minWidth: 45, idealWidth: 75, maxWidth: 100, minHeight: 45, idealHeight: 75, maxHeight: 100, alignment: .topLeading)
//                    .clipShape(Circle())
//                Text("WISDOM")
//                    .font(.caption)
//                    .fontWeight(.bold)
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//            
//            Text(entry.quote)
//                .font(.custom("CormorantGaramond-Italic", size: 16))
//                .foregroundColor(.gray)
//                .lineLimit(4)
//                .minimumScaleFactor(0.8)
//                .multilineTextAlignment(.leading)
//            
//            Spacer()
//        }
//        .padding()
//        .containerBackground(for: .widget) {
//            Color.black
//        }
//    }
//}


struct MotivationWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: family == .systemSmall ? 6 : 10) {
            
            // En-tête : Image dynamique + Titre
            HStack(spacing: 10) {
                Image(authorPhotoName(for: entry.quote))
                    .resizable()
                    .scaledToFill()
                    .frame(width: family == .systemSmall ? 36 : 42,
                           height: family == .systemSmall ? 36 : 42)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("WISDOM")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Spacer(minLength: 0)
            
            // Text de la citation
            Text("“\(entry.quote)”")
                .font(.custom("CormorantGaramond-Italic", size: family == .systemSmall ? 13 : 16))
                .foregroundColor(.white.opacity(0.95))
                .lineLimit(family == .systemSmall ? 4 : 5)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
        }
        .padding(family == .systemSmall ? 12 : 16)
        .containerBackground(for: .widget) {
            Color.black
        }
    }
}

// Assurez-vous que @main est décommenté si c'est le point d'entrée principal du widget
@main
struct WidgetMotivation: Widget {
    let kind: String = "MotivationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MotivationWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Citation du Jour")
        .description("Affiche votre dose quotidienne de sagesse stoïcienne.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
