//
//  CoreDataManager.swift
//  StockList
//
//  Created by Piyush Pandey on 21/11/24.
//

import Foundation
import CoreData

public protocol CoreDataManagerProtocol {
    func saveStocks(_ stocks: [Stock]) -> CoreDataError?
    func fetchLocalStocks(completion: @escaping (Result<[Stock], CoreDataError>) -> Void)
}

final class CoreDataManager: CoreDataManagerProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init(containerName: String = "StockModel") {
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func saveStocks(_ stocks: [Stock]) -> CoreDataError? {
        let backgroundContext = persistentContainer.newBackgroundContext()
        return backgroundContext.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MyStock")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try backgroundContext.execute(deleteRequest)
                
                stocks.forEach { stock in
                    let myStock = NSEntityDescription.insertNewObject(forEntityName: "MyStock", into: backgroundContext) as! MyStock
                    myStock.symbol = stock.symbol
                    myStock.avgPrice = stock.avgPrice
                    myStock.close = stock.close
                    myStock.ltp = stock.ltp
                    myStock.quantity = Int16(stock.quantity)
                }
                
                try backgroundContext.save()
                
                return nil
            } catch {
                return CoreDataError.failedToSave
            }
        }
    }
    
    func fetchLocalStocks(completion: @escaping (Result<[Stock], CoreDataError>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyStock> = MyStock.fetchRequest()
            do {
                let myStocks = try backgroundContext.fetch(fetchRequest)
                let stocks = myStocks.map {
                    Stock(symbol: $0.symbol ?? "Placeholder",
                          quantity: Int($0.quantity),
                          ltp: $0.ltp,
                          avgPrice: $0.avgPrice,
                          close: $0.close)
                }
                completion(.success(stocks))
            } catch {
                completion(.failure(.failedToFetch))
            }
        }
    }
}
