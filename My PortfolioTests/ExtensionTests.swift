//
//  ExtensionTests.swift
//  My PortfolioTests
//
//  Created by Juan Diego Ocampo on 25/03/22.
//

import SwiftUI
import XCTest
@testable import My_Portfolio

class ExtensionTests: XCTestCase {

    func testSequenceKeyPathSorting() {
        let items = (0..<10).map { _ in Int.random(in: 1...100) }
        let sortedItems = items.sorted(by: \.self)
        print(items.sorted())
        print(sortedItems)
        XCTAssertEqual(sortedItems, items.sorted(), "items and sortedItems do not match.")
    }
    
    func testSequenceKeyPathSortingGenericMethod() {
        let items = (0..<10).map { _ in Int.random(in: 1...100) }
        let sortedItems = items.sorted(by: \.self, using: >)
        print(items.sorted().reversed())
        print(sortedItems)
        XCTAssertEqual(sortedItems, items.sorted().reversed(), "items and sortedItems do not match.")
    }
    
    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non empty array.")
    }
    
//    func testDecodingString() {
//        let bundle = Bundle(for: ExtensionTests.self)
//        let test = Bundle.main.decode(String.self, from: "DecodableString.json")
//        let data = bundle.decode(String.self, from: "DecodableString.json")
//        let errorMessage = "Decoded string does not match with the original found on the JSON File."
//        XCTAssertEqual(data, "The rain in Spain falls mainly on the Spaniards.", errorMessage)
//    }
    
//    func testDecodingDictionary() {
//        let bundle = Bundle(for: ExtensionTests.self)
//        let test = Bundle.main.decode([String: Int].self, from: "DecodableDictionary.json")
//        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
//        let errorMessage = "Decoded dictionary does not match with the original found on the JSON File."
//        XCTAssertEqual(data, ["One": 1, "Two": 2, "Three": 3], errorMessage)
//    }
    
    func testBindingOnChange() {
        var onChangeFunctionRun = false
        func exampleFunctionToCall() { onChangeFunctionRun = true }
        var storedValue = ""
        let binding = Binding(get: { storedValue }, set: { storedValue = $0 })
        let changeBinding = binding.onChange { exampleFunctionToCall() }
        changeBinding.wrappedValue = "Test"
        XCTAssertTrue(onChangeFunctionRun, "exampleFunctionToCall did not run - onChangeFunctionRun remains false. ")
    }

}
