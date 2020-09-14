//
//  CurrencyListResult.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/12/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation

struct CurrencyListResult: Codable {
    var terms: String
    var privacy: String
    var currencies: [String: String]
}
