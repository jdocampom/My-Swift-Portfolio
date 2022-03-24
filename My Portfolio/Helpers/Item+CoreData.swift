//
//  Item-CoreDataHelpers.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//
// swiflint:disable: trailing_whitespace

import Foundation

extension Item {
    enum SortOrder {
        case optimized, title, creationDate
    }
    var itemTitle: String { title ?? NSLocalizedString("New Item", comment: "Create a New Item") }
    var itemDetail: String { detail ?? "" }
    var itemCreationDate: Date { creationDate ?? Date() }
    var itemDueDate: Date { dueDate ?? Date() }
//    var itemPriority:     Int16 { priority ?? 1 }
//    var itemCompletion:   Bool { completed ?? false
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "This is an example."
        item.creationDate = Date()
        item.dueDate = Date() + 36000
        item.completed = false
        item.priority = 1
        return item
    }

}
