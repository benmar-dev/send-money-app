//
//  DataStore+Transaction.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation
import SwiftData

extension DataStore {
    
    /// Creates and persists a new wallet transaction.
    func createTransaction(amount: Decimal) async throws -> Transaction {
        
        guard let modelContext else {
            throw TransactionError.creationFailed
        }
        
        let transaction = Transaction(
            createAt: .now,
            transactionNumber: generateTransactionNumber(),
            amount: amount)
        
        modelContext.insert(transaction)
        try modelContext.save()
        return transaction

    }
    
    /// Generates an 8-character reference number, e.g. "A3T92KQ7"
    private func generateTransactionNumber() -> String {
        let characters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let code = (0..<8).compactMap { _ in characters.randomElement() }
        return String(code)
    }
    
    /// Request fetch transaction history from the data store
    func fetchTransactionHistory() async throws -> [Transaction] {
        
        // Fetch transaction history DTOs(data transfer objects) from WalletService
        let dtos = try await walletService.fetchTransactionHistory()
        
        // Resolve the DTOs into SwiftData
        for dto in dtos {
            _ = try upsertTransaction(from: dto)
        }
        
        try modelContext?.save()
        
        // Retrieve the transactions from model context to the caller
        // Sort by latest
        let descriptor = FetchDescriptor<Transaction>(
            sortBy: [
                SortDescriptor(\.createAt, order: .reverse)
            ]
        )
        
        return try modelContext?.fetch(descriptor) ?? []
    }
    
    // Update/insert the transaction instance into the model context
    private func upsertTransaction(from dto: TransactionDTO) throws -> Transaction {

        // Check existing instance of transaction using Transaction.id
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { $0.id == dto.id }
        )

        let existing = try modelContext?.fetch(descriptor).first
        
        let transaction: Transaction
        
        if let existing {
            transaction = existing
            
            // Map the updated fields
            transaction.amount = dto.amount
            transaction.createAt = dto.createAt
            transaction.transactionNumber = dto.transactionNumber
        } else {
            transaction = Transaction(
                id: dto.id,
                createAt: dto.createAt,
                transactionNumber: dto.transactionNumber,
                amount: dto.amount)
            
            modelContext?.insert(transaction)
        }
        
        return transaction
        
    }
}

/// Error for transaction related operations
enum TransactionError: Error, LocalizedError {
    case creationFailed

    var errorDescription: String? {
        switch self {
        case .creationFailed:
            return "Failed to create a transaction"
        }
    }

}
