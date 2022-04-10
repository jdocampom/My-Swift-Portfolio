//
//  ItemListView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 24/03/22.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    @Binding var items: ArraySlice<Item>

    var body: some View {
        if items.isEmpty {
            EmptyView()
//            Text("There are not any open projects at the moment").foregroundColor(.secondary)
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item)) {
                    HStack(spacing: 20) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(Color(item.project?.color ?? "Light Blue"))
                            .frame(width: 17, height: 17)
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
