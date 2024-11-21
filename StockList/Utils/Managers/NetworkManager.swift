//
//  NetworkManager.swift
//  StockList
//
//  Created by Piyush Pandey on 19/11/24.
//

import Foundation

public protocol NetworkManagerProtocol {
    func fetchStocks(completion: @escaping (Result<[Stock], StockListError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    let urlString: String
    
    init(urlString: String = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/") {
        self.urlString = urlString
    }
    
    func fetchStocks(completion: @escaping (Result<[Stock], StockListError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error.asStockListError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let stockResponse = try JSONDecoder().decode(StockResponse.self, from: data)
                completion(.success(stockResponse.data.userHolding))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
}
