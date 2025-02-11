//
//  SharedItemsView.swift
//  ProjectAssistant
//
//  Created by Juan Diego Ocampo on 6/04/22.
//

import CloudKit
import SwiftUI

struct SharedItemsView: View {
    
    let project: SharedProject
    
    @AppStorage("chatCount") var chatCount = 0
    
    @State private var cloudError: CloudError?
    
    @State private var items = [SharedItem]()
    @State private var itemsLoadState = LoadState.inactive
    
    @State private var messages = [ChatMessage]()
    
    @AppStorage("username") var username: String?
    @State private var showingSignIn = false
    @State private var newChatText = ""
    
    @State private var messagesLoadState = LoadState.inactive
    
    @ViewBuilder var messagesFooter: some View {
        if username == nil {
            Button("Sign in to comment", action: signIn)
                .frame(maxWidth: .infinity)
        } else {
            VStack {
                TextField("Enter your message", text: $newChatText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textCase(nil)
                Button(action: sendChatMessage) {
                    Text("Send")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .contentShape(Capsule())
                }
            }
        }
    }
    
    var body: some View {
        List {
            Section {
                switch itemsLoadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResults:
                    Text("No results")
                case .success:
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            
                            if item.detail.isEmpty == false {
                                Text(item.detail)
                            }
                        }
                    }
                }
            }
            Section(
                header: Text("Chat about this project…"),
                footer: messagesFooter
            ) {
                if messagesLoadState == .success {
                    ForEach(messages) { message in
                        Text("\(Text(message.from).bold()): \(message.text)")
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(project.title)
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
        .onAppear {
            fetchSharedItems()
            fetchChatMessages()
        }
        .alert(item: $cloudError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message)
            )
        }
    }
    
    func fetchSharedItems() {
        guard itemsLoadState == .inactive else { return }
        itemsLoadState = .loading
        let recordID = CKRecord.ID(recordName: project.id)
        let reference = CKRecord.Reference(recordID: recordID, action: .none)
        let pred = NSPredicate(format: "project == %@", reference)
        let sort = NSSortDescriptor(key: "title", ascending: true)
        let query = CKQuery(recordType: "Item", predicate: pred)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "detail", "completed"]
        operation.resultsLimit = 50
        operation.recordFetchedBlock = { record in
            let id = record.recordID.recordName
            let title = record["title"] as? String ?? "No title"
            let detail = record["detail"] as? String ?? ""
            let completed = record["completed"] as? Bool ?? false
            
            let sharedItem = SharedItem(id: id, title: title, detail: detail, completed: completed)
            items.append(sharedItem)
            itemsLoadState = .success
        }
        operation.queryCompletionBlock = { _, error in
            if let error = error {
                cloudError = error.getCloudKitError()
            }
            if items.isEmpty {
                itemsLoadState = .noResults
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func signIn() {
        showingSignIn = true
    }
    
    func sendChatMessage() {
        let text = newChatText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 2 else { return }
        guard let username = username else { return }
        let message = CKRecord(recordType: "Message")
        message["from"] = username
        message["text"] = text
        let backupChatText = newChatText
        newChatText = ""
        let projectID = CKRecord.ID(recordName: project.id)
        message["project"] = CKRecord.Reference(recordID: projectID, action: .deleteSelf)
        CKContainer.default().publicCloudDatabase.save(message) { record, error in
            if let error = error {
                cloudError = error.getCloudKitError()
                newChatText = backupChatText
            } else if let record = record {
                let message = ChatMessage(from: record)
                messages.append(message)
                chatCount += 1
            }
        }
    }
    
    func fetchChatMessages() {
        guard messagesLoadState == .inactive else { return }
        messagesLoadState = .loading
        let recordID = CKRecord.ID(recordName: project.id)
        let reference = CKRecord.Reference(recordID: recordID, action: .none)
        let pred = NSPredicate(format: "project == %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: "Message", predicate: pred)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["from", "text"]
        operation.recordFetchedBlock = { record in
            let message = ChatMessage(from: record)
            messages.append(message)
            messagesLoadState = .success
        }
        operation.queryCompletionBlock = { _, error in
            if let error = error {
                cloudError = error.getCloudKitError()
            }
            if messages.isEmpty {
                messagesLoadState = .noResults
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
}
