//
//  CurrencyService.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation

class CurrencyService: NSObject {
    func fetchCurrencyListFromApi() {
        
    }
    
    func fetchCurrencyDataFromApi() {
        
    }
    
    func fetchCurrencyListFromLocal() {
        
    }
    
    func fetchCurrencyDataFromLocal() {
        
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
