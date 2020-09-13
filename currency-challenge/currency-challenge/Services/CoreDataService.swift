//
//  CoreDataService.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/12/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataService {
    static let dbName = "Currency.sqlite"
    var context: NSManagedObjectContext
    
    static func createMainContext() -> NSManagedObjectContext {
        let modelURL = Bundle.main.url(forResource: "CurrencyModel", withExtension: "momd")
        guard let model = NSManagedObjectModel(contentsOf: modelURL!) else {
            fatalError("Model not found!")
        }
        
        let storeURL = URL.documentsURL.appendingPathComponent(CoreDataService.dbName)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }
}

protocol ManagedObjectContextDependentType {
    var managedObjectContext: NSManagedObjectContext! { get set }
}

protocol EntityType {
    static var entityName: String { get set }
}
