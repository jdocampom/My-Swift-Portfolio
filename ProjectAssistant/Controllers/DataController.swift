//
//  DataController.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//

import CoreData
import CoreSpotlight
import StoreKit
import SwiftUI
import WidgetKit

/// An environment singleton responsible for managing our CoreData stack, including handling saving,
/// counting fetch requests, tracking awards and dealing with sample data.
final class DataController: ObservableObject {
    
    /// The lone CloudKit Container used to store our data.
    let container: NSPersistentCloudKitContainer
    
    /// The UserDefaults suite where we're saving user data.
    let defaults: UserDefaults
    
    /// Loads and saves whether our premium unlock has been purchased.
    var fullVersionUnlocked: Bool {
        get { defaults.bool(forKey: "fullVersionUnlocked") }
        set { defaults.set(newValue, forKey: "fullVersionUnlocked") }
    }
    
    /// Initialises a DataController either in memory for temporary use such as testing or preview or on
    /// permanent for regular app usage.
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.co.jdocampom.My-Portfolio"
            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
            }
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ FATAL ERROR LOADING DATA MODEL - ERROR: \(error.localizedDescription) ❌")
            }
            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.clearAll()
                UIView.setAnimationsEnabled(false)
            }
            #endif
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("❌ FATAL ERROR CREATING PREVIEW DATA MODEL - ERROR: \(error.localizedDescription) ❌")
        }
        return dataController
    }()
    
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("❌ FAILED TO LOCATE MODEL FILE ❌")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("❌ FAILED TO LOAD MODEL FILE ❌")
        }
        return managedObjectModel
    }()
    
    /// Creates example projects with items to make manual testing easier.
    /// - Throws: An NSError sent from calling `save()` on the `NSManagedObjectContext`
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
    
    /// Saves our CoreData context if there are changes. This silently ignores any errors caused by saving
    /// but this should be fine because our attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func delete(_ object: Project) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
        container.viewContext.delete(object)
    }
    
    func delete(_ object: Item) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
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
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func update(_ item: Item) {
        let itemID = item.objectID.uriRepresentation().absoluteString
        let projectID = item.project?.objectID.uriRepresentation().absoluteString
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.title
        attributeSet.contentDescription = item.detail
        let searchableItem = CSSearchableItem(
            uniqueIdentifier: itemID,
            domainIdentifier: projectID,
            attributeSet: attributeSet
        )
        CSSearchableIndex.default().indexSearchableItems([searchableItem])
        save()
    }
    
    func item(with uniqueIdentifier: String) -> Item? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }
        
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        return try? container.viewContext.existingObject(with: id) as? Item
    }
    
    @discardableResult func addProject() -> Bool {
        let canCreate = fullVersionUnlocked || count(for: Project.fetchRequest()) < 3
        
        if canCreate {
            let project = Project(context: container.viewContext)
            project.completed = false
            project.creationDate = Date()
            save()
            return true
        } else {
            return false
        }
    }
    
    func fetchRequestForTopItems(count: Int) -> NSFetchRequest<Item> {
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.completed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        itemRequest.predicate = compoundPredicate
        itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
        itemRequest.fetchLimit = count
        return itemRequest
    }
    
    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
    
}
