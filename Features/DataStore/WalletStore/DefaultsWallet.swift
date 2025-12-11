//
//  DefaultsWallet.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// Lightweight concrete implementation of `WalletStore` that uses UserDefaults
/// for retrieving the user's wallet balance.
struct DefaultsWallet: WalletStore {
    
    private let defaults: UserDefaults
    private let balanceKey = "walletBalance"
    private let defaultBalance: Decimal
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.defaultBalance = AppConfig.default.initialBalance
    }
    
    /// Load the balance from UserDefaults
    func loadInitialBalance() -> Decimal {
        if let stored = defaults.string(forKey: balanceKey),
           let value = Decimal(string: stored) {
            return value
        } else {
            return defaultBalance
        }
    }
    
    /// Save new balance to UserDefaults
    func save(balance: Decimal) {
        let stringValue = (balance as NSDecimalNumber).stringValue
        defaults.set(stringValue, forKey: balanceKey)
    }
}
