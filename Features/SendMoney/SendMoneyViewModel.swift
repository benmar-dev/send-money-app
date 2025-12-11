//
//  SendMoneyViewModel.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

@MainActor
class SendMoneyViewModel: ObservableObject {
    
    @Published var amountText: String = ""
    @Published var errorMessage: String?
    @Published var isSending: Bool = false
    @Published var transactionResult: Transaction?
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private var store: DataStore?
        
    var isSendDisabled: Bool {
        amountText.isEmpty || isSending || store == nil
    }
    
    
    /// Connects the view model to the shared DataStore
    func assignDataStore(_ store: DataStore) {
        self.store = store
    }
    
    /// Request to send money via DataStore.
    func sendMoney() {
        
        guard let store else {
            return
        }
        
        errorMessage = nil
        alertMessage = ""
        
        // Trim white spaces and new lines
        let trimmed = amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if valid decimal value
        guard let amount = Decimal(string: trimmed) else {
            errorMessage = ValidationError.invalidAmount.rawValue
            return
        }
        
        // Check if amount is greater than 0
        guard amount > 0 else {
            errorMessage = ValidationError.amountMustBeGreaterThanZero.rawValue
            return
        }
        
        // Check if amount is greater/equal to current balance
        guard amount <= store.walletBalance else {
            errorMessage = ValidationError.insufficientBalance.rawValue
            return
        }
        
        isSending = true
        
        Task {
            defer {
                isSending = false
            }
            do {
                let transaction = try await store.sendMoney(amount: amount)
                transactionResult = transaction
            } catch {
                // Basic error handling eg. when context failed to create Transaction intance
                showAlert = true
                alertMessage = "Something went wrong. Try again later."
            }
        }
        
    }
}

extension SendMoneyViewModel {
    
    /// Validation error message
    enum ValidationError: String {
        case invalidAmount = "Invalid amount."
        case amountMustBeGreaterThanZero = "Please enter an amount greater than 0."
        case insufficientBalance = "Insufficient balance."
    }
}
