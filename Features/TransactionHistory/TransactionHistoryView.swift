//
//  TransactionHistoryView.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import SwiftUI
import SwiftData

struct TransactionHistoryView: View {
    
    @EnvironmentObject private var store: DataStore
    @StateObject private var viewModel = TransactionHistoryViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if viewModel.transactions.isEmpty {
                emptyView
            } else {
                List {
                    ForEach(viewModel.transactions) { transaction in
                        transactionRow(transaction)
                    }
                }
                .listStyle(.plain)
            }
        }
        .task {
            viewModel.assignDataStore(store)
            viewModel.loadTransactions()
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Row
    
    private func transactionRow(_ transaction: Transaction) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // Amount
            Text(transaction.amount.formattedAmount)
                .font(.headline)
            
            // Date
            Text(transaction.createAt.formattedDate)
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            // Reference
            Text("Ref: \(transaction.transactionNumber)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Empty State
    
    private var emptyView: some View {
        VStack(spacing: 8) {
            Text("No Transactions")
                .font(.headline)
            Text("Your recent activity will appear here after you send money.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var loadingView: some View {
        ProgressView("Loading…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

