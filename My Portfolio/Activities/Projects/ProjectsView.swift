//
//  ProjectsView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    private let showClosedProjects: Bool
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var dataController: DataController
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    
    @FetchRequest var projects: FetchedResults<Project>
    
    init(showClosedProjects: Bool) {
        let sortDescriptors = NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        let predicate = NSPredicate(format: "completed = %d", showClosedProjects)
        self.showClosedProjects = showClosedProjects
        _projects = FetchRequest<Project>(entity: Project.entity(),
                                          sortDescriptors: [sortDescriptors],
                                          predicate: predicate)
    }
    
    var projectsList: some View {
        List {
            ForEach(projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { delete($0, from: project) }
                    if !showClosedProjects {
                        Button {
                            addItem(to: project)
                        } label: {
                            Label("Add New Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var addProjectToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !showClosedProjects {
                Button(action: addProject) { Label("New Project", systemImage: "plus") }
            }
        }
    }
    
    var sortItemsToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button { showingSortOrder.toggle() } label: {
                Label("Sort Items", systemImage: "arrow.up.arrow.down")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.isEmpty {
                    Text("There are no projects yet").foregroundColor(.secondary)
                } else {
                    projectsList
                    SelectSomethingView()
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
//            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .toolbar {
                addProjectToolbarButton
                sortItemsToolbarButton
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort Items"), message: nil, buttons: [
                    .default(Text("Automatic")) { sortOrder = .optimized },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title },
                    .cancel()
                ])
            }
        }
    }
}

extension ProjectsView {
    func addProject() {
        withAnimation {
            let project = Project(context: viewContext)
            project.completed = false
            project.creationDate = Date()
            dataController.save()
        }
    }
    
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: viewContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
    }
    
    func delete(_ offsets: IndexSet, from project: Project) {
        let allItems = project.projectItems(using: sortOrder)
        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        dataController.save()
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
