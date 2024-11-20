//
//  StockListError.swift
//  StockList
//
//  Created by Piyush Pandey on 20/11/24.
//

import Foundation

enum StockListError: LocalizedError, Equatable, BaseErrorType {
    
    case networkError(String)
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown
    
    var errorDescription: String {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .invalidURL:
            return "Invalid URL provided"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Error parsing server response"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
