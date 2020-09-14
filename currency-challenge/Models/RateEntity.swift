//
//  RateEntity.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/12/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation
import CoreData

class RateEntity: NSManagedObject, EntityType {
    static var entityName: String = "Rate"
    
    @NSManaged var symbol: String
    @NSManaged var rate: Double
}
