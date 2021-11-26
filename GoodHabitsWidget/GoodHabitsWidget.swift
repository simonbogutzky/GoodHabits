//
//  GoodHabitsWidget.swift
//  GoodHabitsWidget
//
//  Created by Simon Bogutzky on 23.11.21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    typealias Entry = SimpleEntry

    typealias Intent = ColorSelectionIntent

    func getSnapshot(
        for configuration: ColorSelectionIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void) {
            let entry = SimpleEntry(date: Date(), missingStatements: 8, colorIndex: colorIndex(for: configuration))
            completion(entry)
        }

    func getTimeline(
        for configuration: ColorSelectionIntent,
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void) {
            let entries: [SimpleEntry] = [
                SimpleEntry(date: Date(), missingStatements: 8, colorIndex: colorIndex(for: configuration))
            ]

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), missingStatements: 0, colorIndex: 0)
    }

    func colorIndex(for configuration: ColorSelectionIntent) -> Int {
        switch configuration.color {

        case .blue:
            return 0
        case .red:
            return 1
        case .green:
            return 2
        case .yellow:
            return 3
        default:
            return 0
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let missingStatements: Int
    let colorIndex: Int
}

struct GoodHabitsWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        GoodHabitsWidgetView(viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel.previewViewModel)
            .environmentObject(Color.Palette(color: Color.paletteColors[entry.colorIndex]))
    }
}

@main
struct GoodHabitsWidget: Widget {
    let kind: String = "GoodHabitsWidget"

    var body: some WidgetConfiguration {

        IntentConfiguration(kind: kind, intent: ColorSelectionIntent.self, provider: Provider()) { entry in
            GoodHabitsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("GoodHabits Widget")
        .description("GoodHabits widget shows how many behaviors have not been performed today.")
        .supportedFamilies([.systemSmall])
    }
}

struct GoodHabitsWidget_Previews: PreviewProvider {
    static var previews: some View {
        GoodHabitsWidgetView(viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel.previewViewModel)
            .environmentObject(Color.Palette(color: Color.paletteColors[0]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
