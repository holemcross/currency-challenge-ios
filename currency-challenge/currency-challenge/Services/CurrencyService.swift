//
//  CurrencyService.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation
import CoreData

struct CurrencyService {
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchContent() {
        let dataService = DataService()
        print("Before Fetch Currency")
        dataService.fetchCurrencies() { result in
            switch result {
            case .success(let list):
                self.updateCurrencyList(list.currencies)
            case .failure(let error):
                print("Failed to fetch currencies with error:\(error)")
            }
        }
        
        print("Before Fetch Rates")
        dataService.fetchExchangeRates() { result in
            switch result {
            case .success(let rates):
                self.updateRates(rates.quotes, source: rates.source)
            case .failure(let error):
                print("Failed to fetch rates with error:\(error)")
            }
        }
    }
    
    fileprivate func updateCurrencyList(_ list: [String: String]) {
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
            print("Saving New Currency")
            try context.save()
        } catch {
            print(error)
            context.rollback()
        }
    }
    
    fileprivate func updateRates(_ rates: [String: Double], source: String) {
//        print(rates)
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
            print("Symbol After Replace: \(symbol)")
            entity.symbol = symbol
            print("Rate being set: \(element.value)")
            entity.rate = element.value
        }
        do {
            print("Saving new Rates")
            try context.save()
        } catch {
            print(error)
            context.rollback()
        }
    }
    
    func getCurrencySelectionList(with filter: String?) -> [CurrencySelectionItem] {
        var predicate: NSPredicate?
        if let filter = filter, filter.count > 0 {
            predicate = NSPredicate(format: "symbol like %@ OR name like %@", argumentArray: [filter])
        }
        let fetchRequest = NSFetchRequest<CurrencyEntity>(entityName: CurrencyEntity.entityName)
        fetchRequest.predicate = predicate

        if let currencies = try? context.fetch(fetchRequest) {
            return currencies.map { CurrencySelectionItem(symbol: $0.symbol, name: $0.name)}
        }
        return []
    }
    
    func convertCurrency(_ from: String, to: String, amount: Decimal ) -> Decimal {
        // Fetch From USD
        let fromInUsd = Decimal(1.00)
        // Fetch To USD
        let toInUsd = Decimal(1.00)
        
        return (amount / fromInUsd) * toInUsd
    }
    
    func getRowDataFor(currency: String)  {
        
    }
}
