//
//  Stock.swift
//  StockList
//
//  Created by Piyush Pandey on 19/11/24.
//

import Foundation

public struct Stock: Codable{
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}

public struct UserHolding: Codable {
    let userHolding: [Stock]
}

public struct StockResponse: Codable {
    let data: UserHolding
}
