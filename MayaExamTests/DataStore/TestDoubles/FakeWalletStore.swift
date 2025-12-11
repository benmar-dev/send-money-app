//
//  FakeWalletStore.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation
@testable import MayaExam

class FakeWalletStore: WalletStore {
    
    var balance: Decimal
    
    init(balance: Decimal) {
        self.balance = balance
    }
    
    func loadInitialBalance() -> Decimal {
        return balance
    }
    
    func save(balance: Decimal) {
        self.balance = balance
    }

}
