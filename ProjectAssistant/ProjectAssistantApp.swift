//
//  MyPortfolioApp.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 18/03/22.
//
// swiflint:disable: trailing_whitespace

import SwiftUI

@main
struct ProjectAssistantApp: App {
    @StateObject var dataController: DataController
    @StateObject var unlockManager: UnlockManager
    
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                .onReceive(NotificationCenter.default.publisher(for: .willResignActive),
                           perform: save)
                .onAppear(perform: dataController.appLaunched)
        }
    }
    
    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)
        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
        #if targetEnvironment(simulator)
        UserDefaults.standard.set("jdocampom", forKey: "username")
        #endif
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}
