# currency-challenge-ios
- A solution to a coding challenge done in iOS
- Functioning currency calculator for iOS
- Built using SwiftUI and CoreData in Xcode
- Targets iOS version 13.7

Developed by Angel Mortega [Github: Holemcross](https://github.com/holemcross)

## How to run
To run you need to first insert a valid API Key found in the Constants.swift file. 
```
static let apiKey = "Insert Valid Currency Layer API Here"
```
Replace the quoted text with your new api key string.

Open the project in xcode and run from device or simulator.

## Features

* Fetches currency rate information from [Currency Layer](https://currencylayer.com)
* Stores currency data offline for offline use
* Compare and convert currency rates from dozens of currencies
* Filterable currency list for quick selection
* Alerts for data fetch issues
* Data fetches throttled to 30 min increments 

## Dependencies
No outside dependencies were used in this project.

## Webservices
Uses the the free api available from [Currency Layer](https://currencylayer.com) for currency information.