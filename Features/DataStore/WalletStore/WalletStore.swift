//
//  WalletStore.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/11/25.
//

import Foundation

/// An abstraction for storing and retrieving
/// the user's wallet balance.
///
/// - `loadInitialBalance()`  Returns the last persisted wallet balance.
/// - `save(balance:)`        Persists an updated balance value.
protocol WalletStore {
    func loadInitialBalance() -> Decimal
    func save(balance: Decimal)
}
