//
//  DataController.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//
// swiflint:disable: trailing_whitespace

import CoreData
import SwiftUI

final class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                // swiflint:disable:next line_length
                fatalError("❌ FATAL ERROR LOADING DATA MODEL - ERROR: \(error.localizedDescription) ❌")
            }
        }
    }
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        do {
            try dataController.createSampleData()
        } catch {
            // swiflint:disable:next line_length
            fatalError("❌ FATAL ERROR CREATING PREVIEW DATA MODEL - ERROR: \(error.localizedDescription) ❌")
        }
        return dataController
    }()
    func createSampleData () throws {
        let viewContext = container.viewContext
        for projectCounter in 1...5 {
            let project = Project(context: viewContext)
            let timeInterval = Double(360000 * Int.random(in: 1...5))
            project.title = "Project \(projectCounter)"
            project.creationDate = Date()
            project.dueDate = Date() + timeInterval
            project.completed = Bool.random()
            for itemCounter in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.priority = Int16.random(in: 1...3)
                item.project = project
            }
        }
        try viewContext.save()
    }
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    func clearAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    func count<T>(for fecthRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fecthRequest)) ?? 0
    }
    func hasEarnedAward(_ award: Award) -> Bool {
        switch award.criterion {
        case "items":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "complete":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
//            fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}
