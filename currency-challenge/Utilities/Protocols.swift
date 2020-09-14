//
//  Protocols.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/13/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectContextDependentType {
    var managedObjectContext: NSManagedObjectContext! { get set }
}

protocol EntityType {
    static var entityName: String { get set }
}
