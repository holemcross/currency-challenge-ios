//
//  CurrencySelectionView.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import SwiftUI
import Combine

struct CurrencySelectionView: View {
    @Binding var currentSelection: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var filter: String = ""
    @State var currencyList: [CurrencySelectionItem] = []
    var cs:CurrencyService
    
    init(currentSelection: Binding<String>) {
        self._currentSelection = currentSelection
        let cs =  CurrencyService(context: CoreDataService.shared.mainContext)
        self.cs = cs
        self.currencyList = cs.getCurrencySelectionList(with: nil)
    }
    
    func selectedRow(symbol: String) {
        self.currentSelection = symbol
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Text("Choose a base currency that you want to compare rates with.")
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            TextField("Search for currency by name", text: $filter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: nil, height: 44, alignment: .trailing)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            List(currencyList.filter { filter.isEmpty ? true : $0.name.uppercased().contains(filter.uppercased()) || $0.symbol.uppercased().contains(filter.uppercased())}, id: \.symbol) { item in
                    HStack {
                        Text(item.formattedTitle)
                        Spacer()
                        if item.symbol as AnyObject === self.currentSelection as AnyObject {
                            Text("✅")
                        }
                    }.onTapGesture {
                        self.selectedRow(symbol: item.symbol)
                    }
            }
        }
        .navigationBarTitle(Text("Currency Selector"), displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .onTapGesture {
            self.hideKeyboard()
        }
        .onAppear() {
            self.currencyList = self.cs.getCurrencySelectionList(with: nil)
        }
    }
}

struct CurrencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionView(currentSelection: .constant("USD"))
    }
}
