//
//  CurrencyRatesResult.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/12/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation

struct CurrencyRatesResult: Codable {
    var terms: String
    var privacy: String
    var timestamp: Double
    var source: String
    var quotes: [String: Double]
}
