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
    
    fileprivate var cs: CurrencyService
    
    
    init() {
        let cs = CurrencyService(context: CoreDataService.shared.mainContext)
        cs.fetchContent(with: CoreDataService.shared.backgroundContext)
        self.cs = cs
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Selected Currency")
                    Spacer()
                    Text("Amount")
                }.padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16 ))
                HStack {
                    NavigationLink(destination: CurrencySelectionView(currentSelection: $selectedCurrency), label: {
                        Text("\(selectedCurrency)")
                        .padding()
                        .cornerRadius(5)
                    })
                    TextField("Amount", text: $amount)
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
                    ForEach( rowItems, id: \.symbol ) { item in
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
            .onAppear() {
                self.rowItems = self.cs.getAllCurrencyRates()
                self.sourceRate = self.cs.getCurrencyRate(self.selectedCurrency) ?? 1
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
