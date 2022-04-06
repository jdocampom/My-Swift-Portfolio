//
//  ProjectsViewModel.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 25/03/22.
//

import CoreData
import Foundation

extension ProjectsView {
    
    final class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
        let dataController: DataController
        let showClosedProjects: Bool
        var sortOrder = Item.SortOrder.optimized
        
        private let projectsController: NSFetchedResultsController<Project>
        
        @Published var projects = [Project]()
        @Published var showingUnlockView = false
        
        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects
            let sortDescriptors = NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
            let predicate = NSPredicate(format: "completed = %d", showClosedProjects)
            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [sortDescriptors]
            request.predicate = predicate
            projectsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()
            projectsController.delegate = self
            do {
                try projectsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
            } catch {
                print("❌ ERROR - FAILED TO FETCH PROJECTS ❌")
            }
        }
        
        func addProject() {
            if dataController.addProject() == false {
                showingUnlockView.toggle()
            }
        }
        
        func addItem(to project: Project) {
            let item = Item(context: dataController.container.viewContext)
            item.project = project
            item.creationDate = Date()
            item.priority = 0
            item.completed = false
            dataController.save()
        }
        
        func delete(_ offsets: IndexSet, from project: Project) {
            let allItems = project.projectItems(using: sortOrder)
            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }
            dataController.save()
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
            
        }
        
    }
    
}
