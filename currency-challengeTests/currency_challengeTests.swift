//
//  currency_challengeTests.swift
//  currency-challengeTests
//
//  Created by Angel Mortega on 9/9/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import XCTest
import CoreData

@testable import currency_challenge

class currency_challengeTests: XCTestCase {
    var currencyService: CurrencyService!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let contxt = CoreDataService.createInMemoryContext()
        currencyService = CurrencyService(context: contxt)
        context = contxt
    }

    override func tearDownWithError() throws {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        currencyService = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Test Currency Service
    func testCurrencyServiceConversionSimple() throws {
        let fromRate = Double(1)
        let toRate = Double(1)
        let amount = Double(1)
        let expected = Double(1)
        
        let result = CurrencyService.convertCurrency(fromRate, toRate: toRate, amount: amount)
        XCTAssertEqual(result, expected)
    }
    
    func testCurrencyServiceConversionNormal() throws {
        let fromRate = Double(1)
        let toRate = Double(1.4)
        let amount = Double(100)
        let expected = Double(140)
        
        let result = CurrencyService.convertCurrency(fromRate, toRate: toRate, amount: amount)
        XCTAssertEqual(result, expected)
    }
    
    func testCurrencyServiceConversionDividByZero() throws {
        let fromRate = Double(1)
        let toRate = Double(0)
        let amount = Double(1)
        let expected = Double(0)
        
        let result = CurrencyService.convertCurrency(fromRate, toRate: toRate, amount: amount)
        XCTAssertEqual(result, expected)
    }
    
    func testCurrencyServiceUpdateCurrencies() throws {
        
    }
    
    func testCurrencyServiceAddCurrency() throws {
        let symbol = "USD"
        let name = "United States Dollar"
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: CurrencyEntity.entityName, into: self.context) as! CurrencyEntity
        // Transform symbol by removing source str from key
        entity.symbol = symbol
        entity.name = name
        
        do {
            try context.save()
        } catch {
            XCTFail("Should not fail to add")
        }
        
        let fetch = NSFetchRequest<CurrencyEntity>(entityName: CurrencyEntity.entityName)
        do {
            let currencies = try context.fetch(fetch)
            let currency = currencies.first
            XCTAssertEqual(currency?.symbol, symbol)
            XCTAssertEqual(currency?.name, name)
        } catch {
            XCTFail("Should not fail to fetch")
        }
    }
    
    func testCurrencyServiceAddRate() throws {
        let symbol = "USD"
        let rateValue = Double(1)
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: RateEntity.entityName, into: self.context) as! RateEntity
        // Transform symbol by removing source str from key
        entity.symbol = symbol
        entity.rate = rateValue
        
        do {
            try context.save()
        } catch {
            XCTFail("Should not fail to add")
        }
        
        let fetch = NSFetchRequest<RateEntity>(entityName: RateEntity.entityName)
        do {
            let rates = try context.fetch(fetch)
            let rate = rates.first
            XCTAssertEqual(rate?.symbol, symbol)
            XCTAssertEqual(rate?.rate, rateValue)
        } catch {
            XCTFail("Should not fail to fetch")
        }
    }

}
