//
//  SendMoneyViewModelTests.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/11/25.
//

import XCTest
import SwiftData
@testable import MayaExam

@MainActor
class SendMoneyViewModelTests: XCTestCase {
    
    func testSendMoney_whenAmountIsInvalid() throws {
        
        // GIVEN - initial balance of 1000
        let container = try SwiftDataConfig.makeMemoryContainer()
        let context = container.mainContext
        
        let walletStore = FakeWalletStore(balance: 1000)
        
        let store = DataStore(
            modelContext: context,
            walletStore: walletStore
        )

        let viewModel = SendMoneyViewModel()
        viewModel.assignDataStore(store)

        // invalid amount: could be "abc"
        viewModel.amountText = "abc"

        // WHEN
        viewModel.sendMoney()

        // THEN
        XCTAssertEqual(
            viewModel.errorMessage,
            SendMoneyViewModel.ValidationError.invalidAmount.rawValue
        )
        XCTAssertFalse(viewModel.isSending)
        XCTAssertNil(viewModel.transactionResult)
    }
    
    func testSendMoney_whenAmountIsGreaterThanBalance() throws {
        // GIVEN - initial balance of 1000
        let container = try SwiftDataConfig.makeMemoryContainer()
        let context = container.mainContext
        
        let walletStore = FakeWalletStore(balance: 1000)
        
        let store = DataStore(
            modelContext: context,
            walletStore: walletStore
        )

        let viewModel = SendMoneyViewModel()
        viewModel.assignDataStore(store)

        // send 2000, greater than inial balance
        viewModel.amountText = "2000"

        // WHEN
        viewModel.sendMoney()

        // THEN
        XCTAssertEqual(
            viewModel.errorMessage,
            SendMoneyViewModel.ValidationError.insufficientBalance.rawValue
        )
        XCTAssertFalse(viewModel.isSending)
        XCTAssertNil(viewModel.transactionResult)
    }
    
    func testSendMoney_whenAmountIsZero() throws {
        // GIVEN - initial balance of 1000
        let container = try SwiftDataConfig.makeMemoryContainer()
        let context = container.mainContext
        let walletStore = FakeWalletStore(balance: 1000)
        
        let store = DataStore(
            modelContext: context,
            walletStore: walletStore
        )

        let viewModel = SendMoneyViewModel()
        viewModel.assignDataStore(store)
        viewModel.amountText = "0"

        // WHEN
        viewModel.sendMoney()

        // THEN
        XCTAssertEqual(
            viewModel.errorMessage,
            SendMoneyViewModel.ValidationError.amountMustBeGreaterThanZero.rawValue
        )
        XCTAssertFalse(viewModel.isSending)
        XCTAssertNil(viewModel.transactionResult)
    }

    func testSendMoney_whenAmountIsNegative() throws {
        // GIVEN - initial balance of 1000
        let container = try SwiftDataConfig.makeMemoryContainer()
        let context = container.mainContext
        let walletStore = FakeWalletStore(balance: 1000)
        
        let store = DataStore(
            modelContext: context,
            walletStore: walletStore
        )

        let viewModel = SendMoneyViewModel()
        viewModel.assignDataStore(store)
        viewModel.amountText = "-10"

        // WHEN
        viewModel.sendMoney()

        // THEN
        XCTAssertEqual(
            viewModel.errorMessage,
            SendMoneyViewModel.ValidationError.amountMustBeGreaterThanZero.rawValue
        )
        XCTAssertFalse(viewModel.isSending)
        XCTAssertNil(viewModel.transactionResult)
    }
    
    func testSendMoney_success_createsTransactionAndUpdatesVM() async throws {
        // GIVEN - initial balance of 1000
        let container = try SwiftDataConfig.makeMemoryContainer()
        let context = container.mainContext
        let walletStore = FakeWalletStore(balance: 1000)
        
        let store = DataStore(
            modelContext: context,
            walletStore: walletStore
        )

        let vm = SendMoneyViewModel()
        vm.assignDataStore(store)
        
        // valid amount
        vm.amountText = "200"
        
        // WHEN
        vm.sendMoney()
        
        // Add 0.6 secs delay
        // Wait for internal async Task (DataStore has 0.5s delay)
        try await Task.sleep(nanoseconds: 600_000_000)

        // THEN
        // VM state
        XCTAssertFalse(vm.isSending)
        XCTAssertNil(vm.errorMessage)
        XCTAssertNotNil(vm.transactionResult)
        XCTAssertEqual(vm.transactionResult?.amount, 200)

        // DataStore
        XCTAssertEqual(store.walletBalance, 800)
        XCTAssertEqual(walletStore.balance, 800)
    }

        
}

