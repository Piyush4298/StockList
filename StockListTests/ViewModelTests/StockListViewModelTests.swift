//
//  StockListViewModelTests.swift
//  StockListTests
//
//  Created by Piyush Pandey on 21/11/24.
//

import XCTest
@testable import StockList

final class StockListViewModelTests: XCTestCase {

    var sut: StockListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkManager = MockNetworkManager()
        mockCoreDataManager = MockCoreDataManager()
        sut = StockListViewModel(networkManager: mockNetworkManager,
                                 coreDataManager: mockCoreDataManager)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockNetworkManager = nil
        mockCoreDataManager = nil
    }

    func testFetchStocksFromNetworkSuccess() {
        mockNetworkManager.mockStocks = [
            Stock(symbol: "AAPL", quantity: 10, ltp: 150.0, avgPrice: 140.0, close: 145.0),
            Stock(symbol: "GOOGL", quantity: 5, ltp: 2800.0, avgPrice: 2700.0, close: 2750.0)
        ]
        
        sut = StockListViewModel(networkManager: mockNetworkManager, coreDataManager: mockCoreDataManager)
        
        let expectation = self.expectation(description: "Fetch stocks")
        
        sut.fetchStocks { stocks, error in
            XCTAssertNil(error)
            XCTAssertEqual(stocks?.count, 2)
            XCTAssertEqual(stocks?.first?.symbol, "AAPL")
            XCTAssertEqual(self.sut.stockSummary.currentValue, 15500)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchStocksFromLocalOnNetworkFailure() {
        mockNetworkManager.shouldReturnError = true
        
        mockCoreDataManager.mockStocks = [
            Stock(symbol: "MSFT", quantity: 15, ltp: 310.0, avgPrice: 300.0, close: 305.0)
        ]
        sut = StockListViewModel(networkManager: mockNetworkManager, coreDataManager: mockCoreDataManager)
        
        let expectation = self.expectation(description: "Fetch stocks from local")
        
        sut.fetchStocks { stocks, error in
            XCTAssertNil(error)
            XCTAssertEqual(stocks?.count, 1)
            XCTAssertEqual(stocks?.first?.symbol, "MSFT")
            XCTAssertEqual(self.sut.stockSummary.totalInvestment, 4500.0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchStocksFailureFromBothNetworkAndLocal() {
        mockNetworkManager.shouldReturnError = true
        
        mockCoreDataManager.shouldReturnError = true
        
        sut = StockListViewModel(networkManager: mockNetworkManager, coreDataManager: mockCoreDataManager)
        
        let expectation = self.expectation(description: "Fetch stocks failure")
        
        sut.fetchStocks { stocks, error in
            XCTAssertNotNil(error)
            XCTAssertNil(stocks)
            XCTAssertEqual(error as? CoreDataError, .failedToFetch)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testStockSummaryCalculation() {
        mockNetworkManager.mockStocks = [
            Stock(symbol: "TSLA", quantity: 20, ltp: 800.0, avgPrice: 750.0, close: 790.0),
            Stock(symbol: "AMZN", quantity: 10, ltp: 3500.0, avgPrice: 3400.0, close: 3450.0)
        ]
        
        sut = StockListViewModel(networkManager: mockNetworkManager, coreDataManager: mockCoreDataManager)
        
        sut.fetchStocks { _, _ in }
        
        let summary = sut.stockSummary
        
        XCTAssertEqual(summary.currentValue, 51000.0)
        XCTAssertEqual(summary.totalInvestment, 49000.0)
        XCTAssertEqual(summary.totalProfitNLoss, 2000.0)
        XCTAssertEqual(summary.todaysTotalPNL, -700.0)
    }
    
    func testNetworkFailureOnInitialLaunchWithNoLocalData() {
        mockNetworkManager.shouldReturnError = true
        mockCoreDataManager.mockStocks = []
        mockCoreDataManager.shouldReturnError = false
        
        sut = StockListViewModel(networkManager: mockNetworkManager, coreDataManager: mockCoreDataManager)
        
        let expectation = self.expectation(description: "Initial network failure")
        sut.fetchStocks { stocks, error in
            XCTAssertNotNil(error)
            XCTAssertNil(stocks)
            XCTAssertEqual(error as? StockListError, .serverError(500))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLocalDataSaveFailure() {
        mockNetworkManager.shouldReturnError = false
        mockCoreDataManager.shouldReturnError = true
        
        sut = StockListViewModel(networkManager: mockNetworkManager, coreDataManager: mockCoreDataManager)
        
        let expectation = self.expectation(description: "Local Data Save Failure")
        sut.fetchStocks { stocks, error in
            XCTAssertNotNil(error)
            XCTAssertNil(stocks)
            XCTAssertEqual(error as? CoreDataError, .failedToSave)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
}
