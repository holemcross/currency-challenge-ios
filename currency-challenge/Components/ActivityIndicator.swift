//
//  ActivityIndicator.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/14/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        shouldAnimate ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
