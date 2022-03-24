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
    
    @EnvironmentObject var dataController: DataController
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentation
    
    let showClosedProjects: Bool
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    
    @FetchRequest var projects: FetchedResults<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        _projects = FetchRequest<Project>(entity: Project.entity(),
                                          sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)],
                                          predicate: NSPredicate(format: "completed = %d", showClosedProjects))
    }
    
    var body: some View {
        NavigationView {
            Group {
                List {
                    ForEach(projects) { project in
                        Section(header: ProjectHeaderView(project: project)) {
                            ForEach(project.projectItems(using: sortOrder)) { item in
                                ItemRowView(project: project, item: item)
                            }
                            .onDelete { offsets in
                                let allItems = project.projectItems(using: sortOrder)
                                for offset in offsets {
                                    let item = allItems[offset]
                                    dataController.delete(item)
                                }
                                dataController.save()
                            }
                            if !showClosedProjects {
                                Button {
                                    withAnimation {
                                        let item = Item(context: viewContext)
                                        item.project = project
                                        item.creationDate = Date()
                                        dataController.save()
                                    }
                                } label: {
                                    Label("Add New Item", systemImage: "plus")
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                SelectSomethingView()
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !showClosedProjects {
                        Button {
                            withAnimation {
                                let project = Project(context: viewContext)
                                project.completed = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
//                            if UIAccessibility.isVoiceOverRunning {
//                                Text("New Project")
//                            } else {
//                                Label("New Project", systemImage: "plus")
//                            }
                            Label("New Project", systemImage: "plus")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort Items", systemImage: "arrow.up.arrow.down")
                    }
                }
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

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
