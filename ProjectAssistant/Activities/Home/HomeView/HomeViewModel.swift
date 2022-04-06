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
        
        @Published var upNext = ArraySlice<Item>()
        @Published var moreToExplore = ArraySlice<Item>()
        
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
            let itemRequest = dataController.fetchRequestForTopItems(count: 10)
            itemsController = NSFetchedResultsController(
                fetchRequest: itemRequest,
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
                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
            } catch {
                print("❌ ERROR - FAILED TO FETCH INITIAL DATA - HOME VIEW MODEL ❌")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            items = itemsController.fetchedObjects ?? []
            upNext = items.prefix(3)
            moreToExplore = items.dropFirst(3)
            projects = projectsController.fetchedObjects ?? []
        }
        
        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
        
        func selectItem(with identifier: String) {
            selectedItem = dataController.item(with: identifier)
        }
    }
}
