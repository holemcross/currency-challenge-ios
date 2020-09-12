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
//    @State fileprivate var rowItems: [CurrencyRowItem] = []
    
    fileprivate var rowItems: [CurrencyRowItem]
    
    init() {
//        rowItems = []
        rowItems = [CurrencyRowItem(symbol: "JPY", name: "Japanese Yen", amount: 0.94), CurrencyRowItem(symbol: "EUR", name: "Euro", amount: 1.20)]
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
                    //                    .frame(width: 150, height: 90)
                    DoneTextField("Amount", text: $amount, keyboardType: UIKeyboardType.decimalPad, alignment: .right)
                        .frame(width: nil, height: 44, alignment: .trailing)
                        .padding()
                }
                HStack(alignment: .center, spacing: 0) {
                    Text("Currency Name")
                    Spacer()
                    Text("Rate")
                }.padding(EdgeInsets(top: 8, leading: 32, bottom: 8, trailing: 32))
                    .background(Color.gray)
                    .cornerRadius(32, corners: [.topLeft, .topRight])
                List {
                    ForEach( rowItems, id: \.symbol ) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("\(item.symbol) \(item.amount.currencyFormatted)")
                        }.padding()
                    }
                }
            }
            .navigationBarTitle(Text("Currency Converter"), displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
