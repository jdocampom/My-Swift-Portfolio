//
//  ItemRowView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 21/03/22.
//

import SwiftUI

struct ItemRowView: View {
    
    @StateObject var viewModel: ViewModel
    @ObservedObject var item: Item
        
    var label: Text {
        if item.completed {
            return Text("\(item.itemTitle), completed.")
        } else if item.priority == 3 {
            return Text("\(item.itemTitle), high priority.")
        } else if item.priority == 2 {
            return Text("\(item.itemTitle), medium priority.")
        } else {
            return Text("\(item.itemTitle), low priority.")
        }
    }
    
    var iconView: some View {
        Label {
            Text(item.itemTitle)
        } icon: {
            Image(systemName: viewModel.iconViewLabel)
                .foregroundColor(viewModel.iconViewColor.map { Color($0) } ?? .clear)
        }
    }

    var priorityView: some View {
        Image(systemName: viewModel.priorityViewLabel)
            .foregroundColor(viewModel.priorityViewColor.map { Color($0) } ?? .clear)
    }
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            HStack {
                iconView
                Spacer()
                priorityView
            }
            .accessibilityLabel(viewModel.label)
        }
    }
    
    init(project: Project, item: Item) {
        let viewModel = ViewModel(project: project, item: item)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.item = item
    }
    
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
