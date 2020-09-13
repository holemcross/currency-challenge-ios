//
//  Helpers.swift
//  currency-challenge
//
//  Created by Angel Mortega on 9/11/20.
//  Copyright © 2020 mortega. All rights reserved.
//

import Foundation
import SwiftUI

extension String {
    public func replaceFirst(of pattern: String, with replacement: String) -> String {
        if let range = self.range(of: pattern) {
            return self.replacingCharacters(in: range, with: replacement)
        }
        return self
    }
}

extension URL {
    static var documentsURL: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

extension Decimal {
    var currencyFormatted: String {
        get {
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter.string(from: self as NSDecimalNumber) ?? ""
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners:  corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
