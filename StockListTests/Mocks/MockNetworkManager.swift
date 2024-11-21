//
//  MockNetworkManager.swift
//  StockListTests
//
//  Created by Piyush Pandey on 21/11/24.
//

import Foundation
import StockList

final class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockStocks: [Stock] = []
    
    func fetchStocks(completion: @escaping (Result<[Stock], StockListError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.serverError(500)))
        } else {
            completion(.success(mockStocks))
        }
    }
}
