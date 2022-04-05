//
//  SimpleWidget.swift
//  ProjectAssistant
//
//  Created by Juan Diego Ocampo on 4/04/22.
//

import SwiftUI
import WidgetKit

struct PortfolioWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(.secondary)
                    .padding(.trailing)
                Text("Up Next…")
                    .bold()
                    .font(.title3)
                Spacer()
            }
            Spacer()
            if let item = entry.items.first {
                Text(item.itemTitle)
            } else {
                Text("Nothing!")
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical)
    }
}

struct SimplePortfolioWidget: Widget {
    let kind: String = "SimplePortfolioWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PortfolioWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Up Next…")
        .description("Your #1 top-priority item.")
        .supportedFamilies([.systemSmall])
    }
}

struct SimplePortfolioWidget_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
