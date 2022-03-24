//
//  ProjectSummaryView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 24/03/22.
//
// swiflint:disable: trailing_whitespace

import SwiftUI

struct ProjectSummaryView: View {
    @ObservedObject var project: Project
    var body: some View {
        VStack(alignment: .leading) {
            Text(project.projectTitle)
                .font(.title3)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
                .padding(.bottom, 1)
            Text("\(project.projectItems.count) items")
                .font(.caption)
                .foregroundColor(.secondary)
            ProgressView(value: project.completionAmount)
                .accentColor(Color(project.projectColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(project.label)
    }
}

struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummaryView(project: Project.example)
    }
}
