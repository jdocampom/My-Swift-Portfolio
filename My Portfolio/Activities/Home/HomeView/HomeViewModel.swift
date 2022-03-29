//
//  HomeViewModel.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 26/03/22.
//

import CoreData
import CoreSpotlight
import Foundation

extension HomeView {
    
    final class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        
        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>
        
        @Published var projects = [Project]()
        @Published var items = [Item]()
        @Published var selectedItem: Item?
        
        var dataController: DataController
        
        var upNext: ArraySlice<Item> {
            items.prefix(3)
        }
        
        var moreToExplore: ArraySlice<Item> {
            items.dropFirst(3)
        }
        
        init(dataController: DataController) {
            self.dataController = dataController
            
            let projectSortDescriptors = NSSortDescriptor(keyPath: \Project.title, ascending: false)
            let projectPredicate = NSPredicate(format: "completed = false")
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.sortDescriptors = [projectSortDescriptors]
            projectRequest.predicate = projectPredicate
            projectsController = NSFetchedResultsController(
                fetchRequest: projectRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            let
            itemsSortDescriptors = NSSortDescriptor(keyPath: \Item.priority, ascending: false)
            let completedItemsPredicate = NSPredicate(format: "completed = false")
            let openProjectPredicate = NSPredicate(format: "completed = false")
            let itemsPredicate = NSCompoundPredicate(
                type: .and,
                subpredicates: [completedItemsPredicate, openProjectPredicate]
            )
            let itemsRequest: NSFetchRequest<Item> = Item.fetchRequest()
            itemsRequest.sortDescriptors = [itemsSortDescriptors]
            itemsRequest.predicate = itemsPredicate
            itemsController = NSFetchedResultsController(
                fetchRequest: itemsRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            
            projectsController.delegate = self
            itemsController.delegate = self
            
            do {
                try projectsController.performFetch()
                try itemsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("❌ ERROR - FAILED TO FETCH INITIAL DATA - HOME VIEW MODEL ❌")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            } else if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
        
        func addSampleData() {
            dataController.clearAll()
            try? dataController.createSampleData()
        }
        
        func selectItem(with identifier: String) {
            selectedItem = dataController.item(with: identifier)
        }
        
    }
    
}
