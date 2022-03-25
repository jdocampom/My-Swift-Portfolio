//
//  ProjectHeaderView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 21/03/22.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project
    
    var body: some View {
        VStack {
            HStack {
                Text(project.projectTitle)
                Spacer()
                NavigationLink(destination: EditProjectView(project: project)) {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
//                        .accentColor(Color(project.projectColor))
                }
            }
            ProgressView(value: project.completionAmount)
                .accentColor(Color(project.projectColor))
        }
        .padding(.bottom)
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
