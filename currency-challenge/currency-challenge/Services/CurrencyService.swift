//
//  CurrencyService.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation
import CoreData
import Combine

struct CurrencyService {
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchContent(with mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext, callbackHandler: @escaping (Bool)->Void) {
        let dataService = DataService()
        
        dataService.fetchCurrencies( completion: { (result) in
            switch result {
            case .success(let list):
                self.updateCurrencyList(list.currencies, with: backgroundContext, callbackHandler: {_ in })
                dataService.fetchExchangeRates( completion: { (result) in
                    switch result {
                    case .success(let rates):
                        UserDefaults.standard.set(rates.timestamp, forKey: Constants.timestampKey)
                        self.updateRates(rates.quotes, source: rates.source, with: backgroundContext) { (result) in
                            backgroundContext.performAndWait {
                                do {
                                    // Sync contexts
                                    try mainContext.save()
                                    callbackHandler(result)
                                } catch {
                                    print("Failed to sync data across MOCs")
                                    callbackHandler(false)
                                }
                                
                            }
                        }
                    case .failure(let error):
                        print("Failed to fetch rates with error:\(error)")
                        callbackHandler(false)
                    }
                })
            case .failure(let error):
                print("Failed to fetch currencies with error:\(error)")
                callbackHandler(false)
            }
        })
    }
    
    fileprivate func updateCurrencyList(_ list: [String: String], with context: NSManagedObjectContext, callbackHandler: @escaping (Bool)->Void) {
        // Clear existing
        let fetchRequest = NSFetchRequest<CurrencyEntity>(entityName: CurrencyEntity.entityName)
        
        do {
            let oldCurrencies = try context.fetch(fetchRequest)
            let _ = oldCurrencies.map { context.delete($0) }
        } catch {
            print(error)
        }
        
        // Add new currency list
        let _ = list.map { element in
            let entity = NSEntityDescription.insertNewObject(forEntityName: CurrencyEntity.entityName, into: self.context) as! CurrencyEntity
            entity.symbol = element.key
            entity.name = element.value
        }
        do {
            try context.save()
        } catch {
            print(error)
            context.rollback()
        }
    }
    
    fileprivate func updateRates(_ rates: [String: Double], source: String, with context: NSManagedObjectContext,  callbackHandler: @escaping (Bool)->Void) {
        // Clear existing
        let fetchRequest = NSFetchRequest<RateEntity>(entityName: RateEntity.entityName)
        
        do {
            let oldRates = try context.fetch(fetchRequest)
            let _ = oldRates.map { context.delete($0) }
        } catch {
            print(error)
        }
        
        let _ = rates.map { element in
            let entity = NSEntityDescription.insertNewObject(forEntityName: RateEntity.entityName, into: self.context) as! RateEntity
            // Transform symbol by removing source str from key
            let symbol = element.key.replaceFirst(of: source, with: "")
            entity.symbol = symbol
            entity.rate = element.value
        }
        do {
            try context.save()
            callbackHandler(true)
        } catch {
            print(error)
            context.rollback()
            callbackHandler(false)
        }
    }
    
    func getCurrencySelectionList(with filter: String?) -> [CurrencySelectionItem] {
        var predicate: NSPredicate?
        if let filter = filter, filter.count > 0 {
            predicate = NSPredicate(format: "(symbol CONTAINS[c] %@)", filter)
        }
        let sort = NSSortDescriptor(key: "symbol", ascending: true)
        let fetchRequest = NSFetchRequest<CurrencyEntity>(entityName: CurrencyEntity.entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sort]

        if let currencies = try? context.fetch(fetchRequest) {
            return currencies.map { CurrencySelectionItem(symbol: $0.symbol, name: $0.name)}
        }
        return []
    }
    
    func getAllCurrencyRates() -> [CurrencyRowItem] {
        let sort = NSSortDescriptor(key: "symbol", ascending: true)
        let fetchRequest = NSFetchRequest<RateEntity>(entityName: RateEntity.entityName)
        fetchRequest.sortDescriptors = [sort]

        if let rates = try? context.fetch(fetchRequest) {
            print("Collected Rates \(rates.count)")
            return rates.map {
                CurrencyRowItem(symbol: $0.symbol, name: self.getCurrencyNameForSymbol($0.symbol), sourceRate: $0.rate)
            }
        }
        return []
    }
    
    func getCurrencyRate(_ from: String) -> Double? {
        let predicate = NSPredicate(format: "(symbol MATCHES[c] %@)", from)
        let fetchRequest = NSFetchRequest<RateEntity>(entityName: RateEntity.entityName)
        fetchRequest.predicate = predicate

        if let rate = try? context.fetch(fetchRequest).first {
            return rate.rate
        }
        return nil
    }
    
    func getCurrencyNameForSymbol(_ symbol: String) -> String {
        let predicate = NSPredicate(format: "(symbol MATCHES[c] %@)", symbol)
        let fetchRequest = NSFetchRequest<CurrencyEntity>(entityName: CurrencyEntity.entityName)
        fetchRequest.predicate = predicate

        if let currency = try? context.fetch(fetchRequest).first {
            return currency.name
        }
        return ""
    }
    
    static func convertCurrency(_ fromRate: Double, toRate: Double, amount: Double ) -> Double {
        if toRate == 0 {
            return 0
        }
        return (amount / fromRate) * toRate
    }
}
