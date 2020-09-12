//
//  CurrencySelectionView.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import SwiftUI

struct CurrencySelectionView: View {
    @Binding var currentSelection: String
    @State var filter: String = ""
    @State fileprivate var currencyList: [CurrencySelectionItem] = [CurrencySelectionItem(
            symbol: "USD", name: "United States Dollar"),
        CurrencySelectionItem(
            symbol: "JPY", name: "Japanese Yen"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        CurrencySelectionItem(
        symbol: "EUR", name: "European Euro"),
        CurrencySelectionItem(
        symbol: "MXN", name: "Mexican Peso"),
        ]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func selectedRow(symbol: String) {
        print("Tapped with symbol: \(symbol)")
        self.currentSelection = symbol
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Choose a base currency that you want to compare rates with.")
                    .padding()
                DoneTextField("Search for currency by name", text: $filter, keyboardType: UIKeyboardType.alphabet, alignment: .left)
                .frame(width: nil, height: 44, alignment: .trailing)
                .padding()
            }
            List {
                ForEach(currencyList, id: \.symbol) { item in
                    HStack {
                        Text(item.formattedTitle)
                        Spacer()
                        if(item.symbol == self.currentSelection) {
                            Text("✅")
                        }
                        
                    }.onTapGesture {
                        self.selectedRow(symbol: item.symbol)
                    }
                }
            }
        }
        .navigationBarTitle(Text("Currency Selector"), displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CurrencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionView(currentSelection: .constant("USD"))
    }
}
