//
//  ErrorHandlingTests.swift
//  StockListTests
//
//  Created by Piyush Pandey on 21/11/24.
//

import XCTest
@testable import StockList

final class ErrorHandlingTests: XCTestCase {
    func testStockListErrorNetworkError() {
        let error = StockListError.networkError("Connection failed")
        
        XCTAssertEqual(error.errorDescription, "Network Error: Connection failed")
        XCTAssertTrue(error == .networkError("Connection failed"))
        XCTAssertFalse(error == .networkError("Different message"))
    }
    
    func testStockListErrorInvalidURL() {
        let error = StockListError.invalidURL
        
        XCTAssertEqual(error.errorDescription, "Invalid URL provided")
        XCTAssertTrue(error == .invalidURL)
    }
    
    func testStockListErrorNoData() {
        let error = StockListError.noData
        
        XCTAssertEqual(error.errorDescription, "No data received from server")
        XCTAssertTrue(error == .noData)
    }
    
    func testStockListErrorDecodingError() {
        let error = StockListError.decodingError
        
        XCTAssertEqual(error.errorDescription, "Error parsing server response")
        XCTAssertTrue(error == .decodingError)
    }
    
    func testStockListErrorServerError() {
        let error = StockListError.serverError(404)
        
        XCTAssertEqual(error.errorDescription, "Server error with code: 404")
        XCTAssertTrue(error == .serverError(404))
        XCTAssertFalse(error == .serverError(500))
    }
    
    func testStockListErrorUnknown() {
        let error = StockListError.unknown
        
        XCTAssertEqual(error.errorDescription, "An unknown error occurred")
        XCTAssertTrue(error == .unknown)
    }
    
    // MARK: - CoreDataError Tests
    
    func testCoreDataErrorFailedToSave() {
        let error = CoreDataError.failedToSave
        
        XCTAssertEqual(error.errorDescription, "Could not save data locally.")
        XCTAssertTrue(error == .failedToSave)
    }
    
    func testCoreDataErrorFailedToFetch() {
        let error = CoreDataError.failedToFetch
        
        XCTAssertEqual(error.errorDescription, "Could not retrieve local data.")
        XCTAssertTrue(error == .failedToFetch)
    }
    
    // MARK: - Error Extension Tests
    
    func testErrorExtensionWithStockListError() {
        let originalError = StockListError.invalidURL
        let convertedError = originalError.asStockListError
        
        XCTAssertEqual(convertedError, .invalidURL)
    }
    
    func testErrorExtensionWithDecodingError() {
        let originalError = DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: [],
                                  debugDescription: "Corrupted data")
        )
        let convertedError = originalError.asStockListError
        
        XCTAssertEqual(convertedError, .decodingError)
    }
    
    func testErrorExtensionWithUnknownError() {
        let originalError = NSError(domain: "TestDomain", code: 999, userInfo: nil)
        let convertedError = originalError.asStockListError
        
        XCTAssertEqual(convertedError, .unknown)
    }
}
