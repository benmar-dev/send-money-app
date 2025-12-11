//
//  Transaction.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation
import SwiftData

@Model
class Transaction {
    @Attribute(.unique) var id: String
    var createAt: Date
    var transactionNumber: String
    var amount: Decimal
    
    init(id: String = UUID().uuidString, createAt: Date, transactionNumber: String, amount: Decimal) {
        self.id = id
        self.createAt = createAt
        self.transactionNumber = transactionNumber
        self.amount = amount
    }
}
