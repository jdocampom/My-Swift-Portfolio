//
//  Sequence+Ext.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 21/03/22.
//

import Foundation

extension Sequence {
    
    func sorted<Value>(by keyPath: KeyPath<Element, Value>,
                       using areInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows -> [Element] {
        try self.sorted { try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }
    
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        self.sorted(by: keyPath, using: <)
    }
        
}
