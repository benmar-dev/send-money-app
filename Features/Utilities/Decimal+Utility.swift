//
//  Decimal+Utility.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

extension Decimal {
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "PHP"
        return formatter.string(from: self as NSDecimalNumber) ?? "₱0.00"
    }
}
