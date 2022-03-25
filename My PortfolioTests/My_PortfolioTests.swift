//
//  My_PortfolioTests.swift
//  My PortfolioTests
//
//  Created by Juan Diego Ocampo on 25/03/22.
//

import CoreData
import XCTest
@testable import My_Portfolio

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
    
}
