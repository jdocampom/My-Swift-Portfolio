//
//  SharedItem.swift
//  ProjectAssistant
//
//  Created by Juan Diego Ocampo on 6/04/22.
//

import CloudKit

struct SharedItem: Identifiable {
    let id: String
    let title: String
    let detail: String
    let completed: Bool
}
