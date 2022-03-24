//
//  ItemListView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 24/03/22.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    let items: FetchedResults<Item>.SubSequence
    var body: some View {
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
