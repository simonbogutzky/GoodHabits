//
//  GoodHabitsWidget.swift
//  GoodHabitsWidget
//
//  Created by Simon Bogutzky on 23.11.21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), missingStatements: 8)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries: [SimpleEntry] = [SimpleEntry(date: Date(), missingStatements: 8)]

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), missingStatements: 0)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let missingStatements: Int
}

struct GoodHabitsWidgetEntyView: View {
    var entry: Provider.Entry

    var body: some View {
        GoodHabitsWidgetView(data: GoodHabitsWidgetData(missingStatements: entry.missingStatements))
    }
}

@main
struct GoodHabitsWidget: Widget {
    let kind: String = "GoodHabitsWidget"

    var body: some WidgetConfiguration {

        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            GoodHabitsWidgetView(data: GoodHabitsWidgetData(missingStatements: 8))
        }
        .configurationDisplayName("GoodHabits Widget")
        .description("GoodHabits widget shows how many behaviors have not been performed today.")
        .supportedFamilies([.systemSmall])
    }
}

struct GoodHabitsWidget_Previews: PreviewProvider {
    static var previews: some View {
        GoodHabitsWidgetView(data: GoodHabitsWidgetData(missingStatements: 8))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
