//
//  CurrencySelectionItem.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation

class CurrencySelectionItem: Identifiable {
    var symbol: String
    var name: String
    
    init(symbol: String, name: String) {
        self.symbol = symbol
        self.name = name
    }
    
    var formattedTitle: String {
        return "\(self.symbol) - \(self.name)"
    }
}
