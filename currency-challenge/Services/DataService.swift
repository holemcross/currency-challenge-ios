//
//  DataService.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/12/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation

struct DataService {
    static let shared = DataService()
    fileprivate let baseURLString = "http://api.currencylayer.com"
    
    func fetchCurrencies(completion: @escaping (Result<CurrencyListResult, Error>) -> Void) {
        
        guard let validatedURL = self.createURLComponents(path: "/list", params:["access_key": Constants.apiKey])?.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: validatedURL) { (data, response, error) in
            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let currencyList = try JSONDecoder().decode(CurrencyListResult.self, from: validData)
                completion(.success(currencyList))
            } catch let serializationError {
                completion(.failure(serializationError))
            }
        }.resume()
    }
    
    func fetchExchangeRates(completion: @escaping (Result<CurrencyRatesResult, Error>) -> Void) {
        guard let validatedURL = self.createURLComponents(path: "/live", params:["access_key": Constants.apiKey])?.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: validatedURL) { (data, response, error) in
            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let currencyRates = try JSONDecoder().decode(CurrencyRatesResult.self, from: validData)
                completion(.success(currencyRates))
            } catch let serializationError {
                completion(.failure(serializationError))
            }
        }.resume()
    }
    
    fileprivate func createURLComponents(path: String, params: [String: String]?) -> URLComponents? {
        var componentURL = URLComponents()
        componentURL.scheme = "http"
        componentURL.host = "api.currencylayer.com"
        componentURL.path = path
        
        if let params = params {
            componentURL.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value)}
        }
        
        if let _ = componentURL.url {
            return componentURL
        }
        return nil
    }
}
