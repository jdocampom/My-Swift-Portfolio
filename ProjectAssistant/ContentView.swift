//
//  ContentView.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//
// swiflint:disable: trailing_whitespace

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataController: DataController
    @SceneStorage("selectedView") var selectedView: String?
    
    private let newProjectActivity = "co.jdocampom.myPortfolio.newProject"
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ProjectsView(dataController: dataController, showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            ProjectsView(dataController: dataController, showClosedProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
                }
            SharedProjectsView()
                .tag(SharedProjectsView.tag)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Community")
                }
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .onContinueUserActivity(newProjectActivity, perform: createProject)
        .userActivity(newProjectActivity) { activity in
            #if os(iOS) || os(watchOS)
            activity.isEligibleForPrediction = true
            #endif
            activity.title = "Create New Project"
        }
        .onOpenURL(perform: openURL)
    }
    
    func moveToHome(_ input: Any) {
        selectedView = HomeView.tag
    }
    
    func openURL(_ url: URL) {
        selectedView = ProjectsView.openTag
        _ = dataController.addProject()
    }
    
    func createProject(_ userActivity: NSUserActivity) {
        selectedView = ProjectsView.openTag
        dataController.addProject()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
