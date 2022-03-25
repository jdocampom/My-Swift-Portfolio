//
//  EditProjectView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 21/03/22.
//
// swiflint:disable: trailing_whitespace

import SwiftUI

struct EditProjectView: View {
    let project: Project
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteConfirm = false
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    var body: some View {
        Form {
            Section(header: Text("Project Settings")) {
                TextField("Name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            Section(header: Text("Color Label")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            Section(footer: Text("Closing a project moves it from the Open to Closed tab. Deleting it removes the project and any items it contains completely.")) {
                Button(project.completed ? "Reopen this Project" : "Close this Project") {
                    project.completed.toggle()
                    update()
                }
                Button("Delete this Project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete Project"),
                // swiflint:disable:next line_length
                message: Text("Are you sure you want to delete this project? By doing so, you will also delete all the items it contains."),
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
    }
    
    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
    
    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(item == color ? [.isButton, .isButton] : .isButton)
        .accessibilityLabel(LocalizedStringKey(item))
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
