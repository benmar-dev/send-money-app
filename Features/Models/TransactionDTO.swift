//
//  TransactionDTO.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// Data transfer object counterpart of `Transaction` used for API and value-type operations
struct TransactionDTO: Identifiable, Codable {
    let id: String
    let createAt: Date
    let transactionNumber: String
    let amount: Decimal
}
