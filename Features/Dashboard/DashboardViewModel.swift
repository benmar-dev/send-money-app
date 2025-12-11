//
//  DashboardViewModel.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    
    @Published var isBalanceHidden = false
    @Published private(set) var walletBalance: Decimal = 0

    private var store: DataStore?
    private var cancellables = Set<AnyCancellable>()

    /// Connects the view model to the shared DataStore and mirrors its wallet balance.
    func assignDataStore(_ store: DataStore) {
        self.store = store
        
        // Initial value
        walletBalance = store.walletBalance
        
        // Sync the wallet balance with DataStore
        store.$walletBalance
            .sink { [weak self] newValue in
                self?.walletBalance = newValue
            }
            .store(in: &cancellables)
    }
    
}
