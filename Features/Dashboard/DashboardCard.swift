//
//  DashboardCard.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import SwiftUI

struct DashboardCard: View {
    
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top row
            HStack {
                Text("Wallet Balance")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    viewModel.isBalanceHidden.toggle()
                } label: {
                    Image(systemName: viewModel.isBalanceHidden ? "eye.slash" : "eye")
                        .imageScale(.medium)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
            }

            // Balance text (fixed height)
            Text(viewModel.isBalanceHidden ? "••••••" : viewModel.walletBalance.formattedAmount)
                .font(.system(size: 32, weight: .bold))
                .monospacedDigit()
                .frame(height: 40)

            // Action buttons
            HStack(spacing: 12) {

                NavigationLink {
                    SendMoneyView()
                } label: {
                    actionButton(
                        title: "Send",
                        systemImage: "paperplane.fill"
                    )
                }

                NavigationLink {
                    TransactionHistoryView()
                } label: {
                    actionButton(
                        title: "Transactions",
                        systemImage: "list.bullet.rectangle"
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.top)

    }
    
    private func actionButton(title: String, systemImage: String) -> some View {
        HStack {
            Image(systemName: systemImage)
            Text(title)
                .font(.subheadline.bold())
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

}
