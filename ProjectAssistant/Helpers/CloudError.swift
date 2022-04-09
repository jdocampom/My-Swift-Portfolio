//
//  CloudError.swift
//  ProjectAssistant
//
//  Created by Juan Diego Ocampo on 7/04/22.
//

import Foundation
import SwiftUI

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var localizedMessage: LocalizedStringKey { LocalizedStringKey(message) }
    var id: String { message }
    var message: String
    
    init(stringLiteral value: String) {
        self.message = value
    }
}
