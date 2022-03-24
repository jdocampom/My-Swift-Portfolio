//
//  HomeView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//

import CoreData
import SwiftUI

struct HomeView: View {
    
    static let tag: String? = "Home"
    
    var projectRows: [GridItem] { [GridItem(.fixed(100))] }
    
    @EnvironmentObject private var dataController: DataController
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)], predicate: NSPredicate(format: "completed = false")) var projects: FetchedResults<Project>
    
    let items: FetchRequest<Item>
    
    init() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let itemPredicate = NSPredicate(format: "completed = false")
        let projectPredicate = NSPredicate(format: "project.completed = false")
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [itemPredicate, projectPredicate])
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
        request.fetchLimit = 10
        items = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects, content: ProjectSummaryView.init)
                        }
                        .edgesIgnoringSafeArea(.horizontal)
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment: .leading) {
                        ItemListView(title: "Up Next", items: items.wrappedValue.prefix(3))
                        ItemListView(title: "More to Explore", items: items.wrappedValue.dropFirst(3))
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Data") {
                        dataController.clearAll()
                        try? dataController.createSampleData()
                    }
                }
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

