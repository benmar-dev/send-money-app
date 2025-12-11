//
//  TransactionHistoryViewModel.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

@MainActor
class TransactionHistoryViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    @Published var isLoading: Bool = false

    private var store: DataStore?
        
    /// Connects the view model to the shared DataStore
    func assignDataStore(_ store: DataStore) {
        self.store = store
    }
    
    // Load the transaction histroy from the DataStore
    func loadTransactions() {
        
        guard let store else { return }
        
        isLoading = true
        
        Task {
            do {
                let result = try await store.fetchTransactionHistory()
                transactions = result
                isLoading = false
            } catch {
                isLoading = false
            }
        }
        
    }
    
}

