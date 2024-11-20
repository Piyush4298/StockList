//
//  CoreDataError.swift
//  StockList
//
//  Created by Piyush Pandey on 21/11/24.
//

import Foundation

enum CoreDataError: LocalizedError, BaseErrorType {
    case failedToSave
    case failedToFetch
    
    var errorDescription: String {
        switch self {
        case .failedToSave:
            return "Could not save data locally."
        case .failedToFetch:
            return "Could not retrieve local data."
        }
    }
}
