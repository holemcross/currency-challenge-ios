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
    var amount: Decimal
    
    init(symbol: String, name: String, amount: Decimal) {
        self.symbol = symbol
        self.name = name
        self.amount = amount
    }
    
    var rightTitle: String {
        return "\(self.symbol) \(amount.currencyFormatted)"
    }
}
