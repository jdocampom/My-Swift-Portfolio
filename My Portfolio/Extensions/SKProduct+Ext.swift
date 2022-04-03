//
//  SKProduct+Ext.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 3/04/22.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
