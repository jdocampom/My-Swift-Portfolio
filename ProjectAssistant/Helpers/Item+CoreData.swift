//
//  Item-CoreDataHelpers.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//

import Foundation

extension Item {
    enum SortOrder {
        case optimized, title, creationDate
    }

    var itemTitle: String { title ?? NSLocalizedString("New Item", comment: "Create a New Item") }
    var itemDetail: String { detail ?? "" }
    var itemCreationDate: Date { creationDate ?? Date() }
    var itemDueDate: Date { dueDate ?? Date() }

    static var example: Item {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext
        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "This is an example."
        item.creationDate = Date()
        item.dueDate = Date() + 36000
        item.completed = false
        item.priority = 3
        return item
    }
}
