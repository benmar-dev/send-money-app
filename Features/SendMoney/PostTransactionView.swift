//
//  PostTransactionView.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import SwiftUI

struct PostTransactionView: View {

    let transaction: Transaction
    let onBack: () -> Void
    
    
    var body: some View {
        VStack(spacing: 24) {
            
            title
            
            detailCard
            
            Spacer()
            
            backButton
            
        }
        .padding()
    }
    
    private var title: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Transaction Success")
                .font(.title.bold())
            
            Text("Your money has been successfully transfered.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
    
    private var detailCard: some View {
        VStack(spacing: 16) {
            cardRow(label: "Amount", value: transaction.amount.formattedAmount)
            cardRow(label: "Date", value: transaction.createAt.formattedDate)
            cardRow(label: "Reference No.", value: transaction.transactionNumber)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func cardRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline.bold())
                .multilineTextAlignment(.trailing)
        }
    }
    
    private var backButton: some View {
        Button {
            onBack()
        } label: {
            Text("Back to Dashboard")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

