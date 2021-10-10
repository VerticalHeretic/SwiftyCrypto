//
//  PriceWidget.swift
//  PriceWidget
//
//  Created by Łukasz Stachnik on 10/10/2021.
//

import WidgetKit
import SwiftUI
import Intents

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct PriceWidgetEntryView : View {
    var entry: PriceWidgetProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct PriceWidget: Widget {
    let kind: String = "PriceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: PriceWidgetProvider()) { entry in
            PriceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct PriceWidget_Previews: PreviewProvider {
    static var previews: some View {
        PriceWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
