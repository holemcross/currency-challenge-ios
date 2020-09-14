//
//  CurrencyRowItem.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation

class CurrencyRowItem: Identifiable {
    var symbol: String
    var name: String
    var sourceRate: Double
    
    init(symbol: String, name: String, sourceRate: Double) {
        self.symbol = symbol
        self.name = name
        self.sourceRate = sourceRate
    }
    
    func rightTitle(_ fromRate: Double, amount: Double) -> String {
        let calc = CurrencyService.convertCurrency(fromRate, toRate: self.sourceRate, amount: amount)
        return "\(self.symbol) \(String(format: "%.2f", calc))"
//        return "\(self.symbol) \(String(format: "%.2f", self.sourceRate * amount))"
    }
}
