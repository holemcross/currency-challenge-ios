//
//  ContentView.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/9/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State fileprivate var selectedCurrency: String = "USD"
    @State fileprivate var amount: String = "1"
    @State var rowItems: [CurrencyRowItem] = []
    @State var sourceRate: Double = 1
    @State var isLoading: Bool = true
    @State var showAlert: Bool = false
    fileprivate var cs: CurrencyService
    
    init() {
        let cs = CurrencyService(context: CoreDataService.shared.mainContext)
        self.cs = cs
    }
    
    func checkRefresh() {
        let timestamp = UserDefaults.standard.double(forKey: Constants.timestampKey)
        if timestamp != 0 && ((timestamp + Constants.minRefreshTimeInSeconds) < NSDate().timeIntervalSince1970) {
            self.isLoading = false
            self.reloadData()
            return
        }
        self.fetchLatestContent()
    }
    
    func fetchLatestContent() {
        self.isLoading = true
        self.cs.fetchContent(with: CoreDataService.shared.mainContext, backgroundContext: CoreDataService.shared.backgroundContext) { (result) in
            
            if result {
                self.reloadData()
                self.isLoading = false
            } else {
                // Show Refresh alert
                self.showAlert = true
            }
        }
    }
    
    func reloadData() {
        self.rowItems = self.cs.getAllCurrencyRates()
        self.sourceRate = self.cs.getCurrencyRate(self.selectedCurrency) ?? 1
    }
    
    var body: some View {
        let selectedCurrencyBinding = Binding<String>(get: {
            self.selectedCurrency
        }, set: {
            self.selectedCurrency = $0
            self.reloadData()
        })
        return LoadingView(isShowing: $isLoading) {
            NavigationView {
                VStack {
                    HStack {
                        Text("Selected Currency")
                        Spacer()
                        Text("Amount")
                    }.padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16 ))
                    HStack {
                        NavigationLink(destination: CurrencySelectionView(currentSelection: selectedCurrencyBinding), label: {
                            Text("\(self.selectedCurrency)")
                                .padding()
                                .cornerRadius(5)
                        })
                        TextField("Amount", text: self.$amount)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: nil, height: 44, alignment: .trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Text("Currency Name")
                            .fontWeight(.bold)
                        Spacer()
                        Text("Rate")
                            .fontWeight(.bold)
                    }
                    .padding(EdgeInsets(top: 8, leading: 32, bottom: 8, trailing: 32))
                    .background(Color.gray)
                    .cornerRadius(32, corners: [.topLeft, .topRight])
                    
                    List {
                        ForEach( self.rowItems, id: \.symbol ) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.rightTitle(self.sourceRate, amount: (self.amount as NSString).doubleValue))
                            }
                            
                        }
                    }
                }
                .navigationBarTitle(Text("Currency Converter"), displayMode: .inline)
                .navigationViewStyle(StackNavigationViewStyle())
                .onTapGesture {
                    self.hideKeyboard()
                }
                
            }
        }.onAppear() {
            self.checkRefresh()
        }
        .actionSheet(isPresented: self.$showAlert) {
            ActionSheet(
                title: Text("Failed to fetch rates"),
                message: Text("We were unable to get the latest rates. Check your internet connection and hit refresh to try again."),
                buttons: [
                    .cancel { self.showAlert = false },
                    .default(Text("Refresh")) {
                        self.showAlert = false
                        self.fetchLatestContent()
                    }
            ])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
