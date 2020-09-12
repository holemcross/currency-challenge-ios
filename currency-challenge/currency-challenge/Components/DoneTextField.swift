//
//  DoneTextField.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/12/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import SwiftUI

struct DoneTextField: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    @Binding var text: String
    private var placeholder: String
    var keyboardType: UIKeyboardType
    var alignment: NSTextAlignment
    
    init(_ placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType?, alignment: NSTextAlignment?) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType ?? UIKeyboardType.default
        self.alignment = alignment ?? NSTextAlignment.left
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyboardType
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.textAlignment = alignment
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
        let clearButton = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(textField.clearButtonTapped(button:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([clearButton, spacer, doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
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
