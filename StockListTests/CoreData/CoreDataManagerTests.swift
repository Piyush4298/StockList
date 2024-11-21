//
//  CoreDataManagerTests.swift
//  StockListTests
//
//  Created by Piyush Pandey on 21/11/24.
//

import CoreData
import XCTest
@testable import StockList

final class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let container = NSPersistentContainer(name: "StockModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "CoreData Setup")
        container.loadPersistentStores { _, error in
            if let error = error {
                XCTFail("Failed to set up in-memory store: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        coreDataManager = CoreDataManager(containerName: "StockModel")
        testContext = container.viewContext
    }
    
    override func tearDown() {
        coreDataManager = nil
        testContext = nil
        super.tearDown()
    }
    
    func testSaveStocks() {
        let testStocks = [
            Stock(symbol: "AAPL", quantity: 10, ltp: 150.50, avgPrice: 145.00, close: 152.75),
            Stock(symbol: "GOOGL", quantity: 5, ltp: 1200.00, avgPrice: 1180.50, close: 1210.00)
        ]
        
        let saveError = coreDataManager.saveStocks(testStocks)
        XCTAssertNil(saveError, "Stocks should be saved without error")
        
        let fetchExpectation = expectation(description: "Fetch Stocks")
        coreDataManager.fetchLocalStocks { result in
            switch result {
            case .success(let fetchedStocks):
                XCTAssertEqual(fetchedStocks.count, 2, "Should fetch 2 saved stocks")
                let stockSymbols = fetchedStocks.map { stock in
                    return stock.symbol
                }
                XCTAssertTrue(stockSymbols.contains(where: { symbol in
                    symbol == "AAPL"
                }))
                XCTAssertTrue(stockSymbols.contains(where: { symbol in
                    symbol == "GOOGL"
                }))
            case .failure(let error):
                XCTFail("Failed to fetch stocks: \(error)")
            }
            fetchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchEmptyStocks() {
        _ = coreDataManager.saveStocks([])
        let fetchExpectation = expectation(description: "Fetch Empty Stocks")
        coreDataManager.fetchLocalStocks { result in
            switch result {
            case .success(let stocks):
                XCTAssertTrue(stocks.isEmpty, "Should return empty array when no stocks")
            case .failure:
                XCTFail("Should not fail when fetching empty stocks")
            }
            fetchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testOverwriteExistingStocks() {
        let initialStocks = [
            Stock(symbol: "AAPL", quantity: 10, ltp: 150.50, avgPrice: 145.00, close: 152.75)
        ]
        _ = coreDataManager.saveStocks(initialStocks)
        
        let newStocks = [
            Stock(symbol: "GOOGL", quantity: 5, ltp: 1200.00, avgPrice: 1180.50, close: 1210.00)
        ]
        let saveError = coreDataManager.saveStocks(newStocks)
        XCTAssertNil(saveError, "Should overwrite existing stocks")
        
        let fetchExpectation = expectation(description: "Verify Overwrite")
        coreDataManager.fetchLocalStocks { result in
            switch result {
            case .success(let fetchedStocks):
                XCTAssertEqual(fetchedStocks.count, 1, "Should only have new stocks")
                XCTAssertEqual(fetchedStocks[0].symbol, "GOOGL")
            case .failure(let error):
                XCTFail("Failed to fetch stocks: \(error)")
            }
            fetchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
