//
//  PortfolioWidget.swift
//  PortfolioWidget
//
//  Created by Juan Diego Ocampo on 3/04/22.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [Item.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    func loadItems() -> [Item] {
        let dataController = DataController()
        let itemRequest = dataController.fetchRequestForTopItems(count: 1)
        return dataController.results(for: itemRequest)
    }
    
}

struct SimpleEntry: TimelineEntry {
    
    let date: Date
    let items: [Item]
    
}

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

@main
struct PortfolioWidget: Widget {
    
    let kind: String = "PortfolioWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PortfolioWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
    
}

struct PortfolioWidget_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
