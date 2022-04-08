//
//  CloudError.swift
//  ProjectAssistant
//
//  Created by Juan Diego Ocampo on 7/04/22.
//

import Foundation

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String
    
    init(stringLiteral value: String) {
        self.message = value
    }
}
