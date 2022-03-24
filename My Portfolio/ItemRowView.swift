//
//  ItemRowView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 21/03/22.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    
    var iconView: some View {
        if item.completed {
            return Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "circle")
                .foregroundColor(Color(project.projectColor))
        }
    }
    
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
    
    var priorityView: some View {
        if !item.completed {
            switch item.priority {
            case 1:
                return Image(systemName: "exclamationmark")
                    .foregroundColor(.clear)
            case 2:
                return Image(systemName: "exclamationmark")
                    .foregroundColor(Color(project.projectColor))
            case 3:
                return Image(systemName: "exclamationmark.3")
                    .foregroundColor(Color(project.projectColor))
            default:
                return Image(systemName: "circle")
                    .foregroundColor(.clear)
            }
        } else {
            return Image(systemName: "circle")
                .foregroundColor(.clear)
        }
    }
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            HStack {
                Label { Text(item.itemTitle) } icon: { iconView }
                Spacer()
                priorityView
            }
            .accessibilityLabel(label)
        }
    }
    
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
