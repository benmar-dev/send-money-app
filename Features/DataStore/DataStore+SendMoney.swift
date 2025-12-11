//
//  DataStore+SendMoney.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

extension DataStore {
    
    /// Simulates a money transfer operation.
    func sendMoney(amount: Decimal) async throws -> Transaction {
        // Add delay of 0.5 seconds (simulate)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Create transaction
        do {
            let transaction = try await createTransaction(amount: amount)
            
            // Perform operation and update balance after transaction is created
            let newBalance = walletBalance - amount
            setWalletBalance(newBalance)
            
            return transaction
        }
        
    }
    
}
