//
//  DoneTextField.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/12/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import SwiftUI

class WrappableTextField: UITextField, UITextFieldDelegate {
    var textFieldChangedHandler: ((String)->Void)?
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let currentValue = textField.text as NSString? {
            let proposedValue = currentValue.replacingCharacters(in: range, with: string)
            print(proposedValue)
            textFieldChangedHandler?(proposedValue as String)
        }
        return true
    }
}

struct DoneTextField: UIViewRepresentable {
    typealias UIViewType = WrappableTextField
    
    @Binding var text: String
    private var placeholder: String
    var keyboardType: UIKeyboardType
    var alignment: NSTextAlignment
    var changeHandler: ((String)->Void)?
    
    private let tempView = WrappableTextField()
    
    init(_ placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType?, alignment: NSTextAlignment?, changeHandler: ((String)->Void)?) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType ?? UIKeyboardType.default
        self.alignment = alignment ?? NSTextAlignment.left
        self.changeHandler = changeHandler
    }
    
    func makeUIView(context: Context) -> WrappableTextField {
        tempView.keyboardType = keyboardType
        tempView.placeholder = placeholder
        tempView.borderStyle = .roundedRect
        tempView.textAlignment = alignment
        tempView.delegate = tempView
        tempView.textFieldChangedHandler = changeHandler
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: tempView.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tempView.doneButtonTapped(button:)))
        let clearButton = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(tempView.clearButtonTapped(button:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([clearButton, spacer, doneButton], animated: true)
        
        tempView.inputAccessoryView = toolbar
        return tempView
    }
    
    func updateUIView(_ uiView: WrappableTextField, context: Context) {
        uiView.text = text
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

extension UITextField {
    @objc func doneButtonTapped(button: UIBarButtonItem) -> Void {
        self.resignFirstResponder()
    }
    
    @objc func clearButtonTapped(button: UIBarButtonItem) -> Void {
        self.text = ""
    }
}

struct DoneTextField_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
