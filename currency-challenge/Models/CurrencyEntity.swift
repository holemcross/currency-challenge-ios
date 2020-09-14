//
//  CurrencyEntity.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/12/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation
import CoreData

class CurrencyEntity: NSManagedObject, EntityType {
    static var entityName: String = "Currency"
    
    @NSManaged var symbol: String
    @NSManaged var name: String
}
