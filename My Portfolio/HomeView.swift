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
        request.predicate = NSPredicate(format: "completed = false")
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
                            ForEach(projects) { project in
                                VStack(alignment: .leading) {
                                    Text("\(project.projectItems.count) items")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(project.projectTitle)
                                        .font(.title3)
                                        .minimumScaleFactor(0.75)
                                        .lineLimit(1)
                                    ProgressView(value: project.completionAmount)
                                        .accentColor(Color(project.projectColor))
                                }
                                .padding()
                                .background(Color.secondarySystemGroupedBackground)
                                .cornerRadius(10)
                                //                                .shadow(color: Color.black.opacity(0.2), radius: 5)
                            }
                        }
                        .edgesIgnoringSafeArea(.horizontal)
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment: .leading) {
                        list("Up Next", for: items.wrappedValue.prefix(3))
                        list("More to Explore", for: items.wrappedValue.dropFirst(3))
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
            .background(Color.systemGroupedBackground.ignoresSafeArea())
        }
    }
    
    
    @ViewBuilder func list(_ title: String, for items: FetchedResults<Item>.SubSequence) -> some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(item.project?.color ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 28, height: 28)
                        VStack(alignment: .leading) {
                            Text(item.itemTitle)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if !item.itemDetail.isEmpty {
                                Text(item.itemDetail)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    
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


//Button("Add Data") {
//    dataController.clearAll()
//    try? dataController.createSampleData()
//    }
