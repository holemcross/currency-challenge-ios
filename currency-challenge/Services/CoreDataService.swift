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
    static let resourceName = "CurrencyModel"
    static let dbName = "Currency.sqlite"
    static let shared = CoreDataService()
    var mainContext: NSManagedObjectContext!
    var backgroundContext: NSManagedObjectContext!
    
    init() {
        mainContext = CoreDataService.createMainContext()
        backgroundContext = CoreDataService.createBackgroundContext()
    }
    
    static func createMainContext() -> NSManagedObjectContext {
        let modelURL = Bundle.main.url(forResource: CoreDataService.resourceName, withExtension: "momd")
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
    
    static func createBackgroundContext() -> NSManagedObjectContext {
        let modelURL = Bundle.main.url(forResource: CoreDataService.resourceName, withExtension: "momd")
        guard let model = NSManagedObjectModel(contentsOf: modelURL!) else {
            fatalError("Model not found!")
        }
        
        let storeURL = URL.documentsURL.appendingPathComponent(CoreDataService.dbName)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }
    
    static func createInMemoryContext() -> NSManagedObjectContext {
        let modelURL = Bundle.main.url(forResource: CoreDataService.resourceName, withExtension: "momd")
        guard let model = NSManagedObjectModel(contentsOf: modelURL!) else {
            fatalError("Model not found!")
        }
        
        let storeURL = URL.documentsURL.appendingPathComponent(CoreDataService.dbName)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: storeURL, options: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }
}
