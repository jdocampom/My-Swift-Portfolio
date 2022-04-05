//
//  SelectSomethingView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 22/03/22.
//

import SwiftUI

struct SelectSomethingView: View {
    var body: some View {
        ZStack(alignment: .center) {
//        Color.systemGroupedBackground.ignoresSafeArea()
        Text("Please select something from the menu to begin.")
            .italic()
            .foregroundColor(.secondary)
        }
    }
}

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
