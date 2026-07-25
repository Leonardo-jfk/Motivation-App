//
//  WidgetMotivationLiveActivity.swift
//  WidgetMotivation
//
//  Created by Leonardo Aurelio on 25/07/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetMotivationAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetMotivationLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetMotivationAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetMotivationAttributes {
    fileprivate static var preview: WidgetMotivationAttributes {
        WidgetMotivationAttributes(name: "World")
    }
}

extension WidgetMotivationAttributes.ContentState {
    fileprivate static var smiley: WidgetMotivationAttributes.ContentState {
        WidgetMotivationAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetMotivationAttributes.ContentState {
         WidgetMotivationAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetMotivationAttributes.preview) {
   WidgetMotivationLiveActivity()
} contentStates: {
    WidgetMotivationAttributes.ContentState.smiley
    WidgetMotivationAttributes.ContentState.starEyes
}
