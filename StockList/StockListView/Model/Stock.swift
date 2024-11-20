//
//  Stock.swift
//  StockList
//
//  Created by Piyush Pandey on 19/11/24.
//

import Foundation

struct Stock: Decodable{
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}

struct UserHolding: Decodable {
    let userHolding: [Stock]
}

struct StockResponse: Decodable {
    let data: UserHolding
}
