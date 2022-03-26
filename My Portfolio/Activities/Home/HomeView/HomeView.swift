//
//  HomeView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: ViewModel
    
    static let tag: String? = "Home"
    
    var projectRows: [GridItem] { [GridItem(.fixed(100))] }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects, content: ProjectSummaryView.init)
                        }
                        .edgesIgnoringSafeArea(.horizontal)
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment: .leading) {
                        ItemListView(title: "Up Next", items: viewModel.upNext)
                        ItemListView(title: "More to Explore", items: viewModel.moreToExplore)
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            #if DEBUG
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Sample Data", action: viewModel.addSampleData)
                }
            }
            #endif
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}
