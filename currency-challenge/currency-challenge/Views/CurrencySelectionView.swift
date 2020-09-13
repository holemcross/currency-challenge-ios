//
//  CurrencySelectionView.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import SwiftUI

struct CurrencySelectionView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var currentSelection: String
    @State var filter: String = ""
    @State fileprivate var currencyList: [CurrencySelectionItem] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(currentSelection: Binding<String>) {
        self._currentSelection = currentSelection
        self.updateSelectionList(nil)
    }
    
    func updateSelectionList(_ filter: String?) {
        let cs = CurrencyService(context: managedObjectContext)
        self.currencyList = cs.getCurrencySelectionList(with: filter)
        print("Getting Currency Selection List with results \(self.currencyList)")
    }
    
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
        .onAppear( perform: {
                self.updateSelectionList(nil)
            })
    }
}

struct CurrencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionView(currentSelection: .constant("USD"))
    }
}
