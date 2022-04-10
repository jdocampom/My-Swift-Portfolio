//
//  HomeView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//

import CoreSpotlight
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
                        ItemListView(title: "Up Next", items: $viewModel.upNext)
                        ItemListView(title: "More to Explore", items: $viewModel.moreToExplore)
                    }
                    .padding()
                }
                if let item = viewModel.selectedItem {
                    NavigationLink(
                        destination: EditItemView(item: item),
                        tag: item,
                        selection: $viewModel.selectedItem,
                        label: EmptyView.init
                    )
                    .id(item)
                }
            }
            .navigationTitle("Home")
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
            #if DEBUG
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Add Sample Data", action: viewModel.addSampleData)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button("Delete All", action: viewModel.dataController.deleteAll)
                    }
                }
            #endif
        }
    }
    
    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            viewModel.selectItem(with: uniqueIdentifier)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}
