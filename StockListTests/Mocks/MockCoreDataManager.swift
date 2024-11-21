//
//  MockCoreDataManager.swift
//  StockListTests
//
//  Created by Piyush Pandey on 21/11/24.
//

import Foundation
import StockList

final class MockCoreDataManager: CoreDataManagerProtocol {
    var shouldReturnError = false
    var mockStocks: [Stock] = []
    
    func saveStocks(_ stocks: [Stock]) -> CoreDataError? {
        return shouldReturnError ? .failedToSave : nil
    }
    
    func fetchLocalStocks(completion: @escaping (Result<[Stock], CoreDataError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.failedToFetch))
        } else {
            completion(.success(mockStocks))
        }
    }
}
