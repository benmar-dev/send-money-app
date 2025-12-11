//
//  DataStore.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import Foundation
import SwiftData

/// `DataStore` acts as the application's primary state container and single source of truth.
/// It centralizes access to authentication, wallet operations, persistence (SwiftData),
/// and session management. Views and view models interact with this class to perform
/// user-facing actions while keeping business logic separate from UI.
///
/// Responsibilities:
/// - Manage user authentication state (`authService`, `sessionStore`)
/// - Persist and expose wallet balance (`walletStore`, `walletBalance`)
/// - Provide access to transaction history and SwiftData persistence (`modelContext`)
/// - Initialize and maintain session state across app launches
///
/// The store is annotated with `@MainActor` to ensure UI-bound state changes are safe.
/// All dependencies are injected, enabling modular design and testability.
@MainActor
class DataStore: ObservableObject {

    let modelContext: ModelContext?
    let authService: AuthService
    let walletService: WalletService
    let sessionStore: SessionStore
    let walletStore: WalletStore

    @Published var isAuthenticated: Bool = false
    @Published private(set) var walletBalance: Decimal

    /// Sets up the data store dependencies and loads initial state.
    init(modelContext: ModelContext? = nil,
         authService: AuthService = AuthService(),
         walletService: WalletService = WalletService(),
         sessionStore: any SessionStore = KeychainSession(),
         walletStore: WalletStore = DefaultsWallet()) {
            
        self.modelContext = modelContext
        self.authService = authService
        self.walletService = walletService
        self.sessionStore = sessionStore
        self.walletStore = walletStore
        self.walletBalance = walletStore.loadInitialBalance()
        
        loadSession()
    }
    
    // MARK: Wallet Balance
    
    /// Updates the current wallet balance and persists the value using the configured `walletStore`.
    func setWalletBalance(_ newValue: Decimal) {
        walletBalance = newValue
        walletStore.save(balance: newValue)
    }

}
