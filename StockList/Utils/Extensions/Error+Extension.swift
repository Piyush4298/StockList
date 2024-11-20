//
//  Error+Extension.swift
//  StockList
//
//  Created by Piyush Pandey on 20/11/24.
//

import Foundation

extension Error {
    var asStockListError: StockListError {
        switch self {
        case let error as StockListError:
            return error
        case let error as URLError:
            return .networkError(error.localizedDescription)
        case _ as DecodingError:
            return .decodingError
        default:
            return .unknown
        }
    }
}
