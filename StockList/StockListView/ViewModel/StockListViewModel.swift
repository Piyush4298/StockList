//
//  StockListViewModel.swift
//  StockList
//
//  Created by Piyush Pandey on 19/11/24.
//

import Foundation

final class StockListViewModel {
    private let networkManager: NetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private var stocks = [Stock]()
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(),
         coreDataManager: CoreDataManagerProtocol = CoreDataManager()) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
    }
    
    func fetchStocks(completion: @escaping ([Stock]?, BaseErrorType?) -> Void) {
        networkManager.fetchStocks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let stocks):
                self.stocks = stocks
                if let error =  self.coreDataManager.saveStocks(stocks) {
                    completion(nil, error)
                    return
                }
                completion(stocks, nil)
            case .failure(let error):
                self.coreDataManager.fetchLocalStocks { result in
                    switch result {
                    case .success(let stocks):
                        self.stocks = stocks
                        guard !stocks.isEmpty else {
                            completion(nil, error)
                            return
                        }
                        completion(stocks, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
            }
        }
    }

    private var currentValue: Double {
        return stocks.reduce(0) { result, stock in
            result + (stock.ltp * Double(stock.quantity))
        }
    }
    
    private var totalInvestment: Double {
        return stocks.reduce(0) { result, stock in
            result + (stock.avgPrice * Double(stock.quantity))
        }
    }
    
    private var totalPNL: Double {
        return currentValue - totalInvestment
    }
    
    private var todaysPNL: Double {
        return stocks.reduce(0) { result, stock in
            result + ((stock.close - stock.ltp) * Double(stock.quantity))
        }
    }
    
    var stockSummary: StocksSummary {
        return .init(totalProfitNLoss: totalPNL,
                     currentValue: currentValue,
                     totalInvestment: totalInvestment,
                     todaysTotalPNL: todaysPNL)
    }
}
