//
//  Binding+Ext.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 21/03/22.
//
// swiflint:disable: trailing_whitespace

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
