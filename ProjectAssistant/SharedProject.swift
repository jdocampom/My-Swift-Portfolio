//
//  SharedProject.swift
//  ProjectAssistant
//
//  Created by Juan Diego Ocampo on 6/04/22.
//

import CloudKit

struct SharedProject: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool
    
    static let example = SharedProject(id: "1", title: "Example", detail: "Detail", owner: "TwoStraws", closed: false)
}
