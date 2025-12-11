//
//  DataStore_SendMoney_Tests.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import XCTest
import SwiftData
@testable import MayaExam

@MainActor
class DataStore_SendMoney_Tests: XCTestCase {
    
    func test_sendMoney_success() async throws {
        
        // GIVEN - initial balance of 1000
        let container = try SwiftDataConfig.makeMemoryContainer()
        let context = container.mainContext
        
        let walletStore = FakeWalletStore(balance: 1000)
        
        let store = DataStore(
            modelContext: context,
            walletStore: walletStore
        )
        
        // WHEN
        let transaction = try await store.sendMoney(amount: 200)
        
        // Asserts
        // - Transaction is created
        // - Transaction is persisted in context
        // - DataStore balance is updated
        // - DataStore.walletStore balance is updated

        // Transaction returned
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction.amount, 200)
        
        // Transaction should persist into SwiftData
        let all = try context.fetch(FetchDescriptor<Transaction>())
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all.first?.amount, 200)
        
        // Update DataStore balance
        XCTAssertEqual(store.walletBalance, 800)
        
        // Update DataStore.walletStore balance
        XCTAssertEqual(walletStore.balance, 800)
    }

    func testSendMoney_failure() async throws {
        
        // GIVEN - initial balance of 1000, null container
        let walletStore = FakeWalletStore(balance: 1000)
        
        let store = DataStore(
            modelContext: nil,
            walletStore: walletStore
        )

        // Assert - before sending money, dataStore and wallet balance
        // should be 1000 (initial)
        XCTAssertEqual(store.walletBalance, 1000)
        XCTAssertEqual(walletStore.balance, 1000)
        
        // WHEN + THEN
        do {
            _ = try await store.sendMoney(amount: 200)
            XCTFail("Expected sendMoney to throw")
            
        } catch let error as TransactionError {
            XCTAssertEqual(
                error.errorDescription,
                TransactionError.creationFailed.errorDescription
            )
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        // Assert — no balance change
        XCTAssertEqual(store.walletBalance, 1000)
        XCTAssertEqual(walletStore.balance, 1000)
    }

        
}

