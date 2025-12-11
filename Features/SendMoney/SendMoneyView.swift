//
//  SendMoneyView.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import SwiftUI

struct SendMoneyView: View {
    
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = SendMoneyViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            
            // title
            title
            
            // send field
            sendField

            // send button
            sendButton
            
            if let errorMessage = viewModel.errorMessage {
                errorText(errorMessage)
            }
            
            Spacer()
        }
        .padding()
        .task {
            viewModel.assignDataStore(store)
        }
        .fullScreenCover(item: $viewModel.transactionResult) { transaction in
            PostTransactionView(transaction: transaction) {
                viewModel.transactionResult = nil
                dismiss()
            }
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("OK") { }
        }

    }
    
    private var title: some View {
        Text("Send Money")
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var sendField: some View {
        VStack(spacing: 12) {
            
            let backgroundColor = viewModel.errorMessage == nil ?
                Color(.secondarySystemBackground) :
                Color.red.opacity(0.2)
            
            Text("Enter the amount you want to send.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("₱")
                    .font(.title2.bold())
                TextField("0.00", text: $viewModel.amountText)
                    .keyboardType(.decimalPad)
                    .font(.title2)
                    .disabled(viewModel.isSending)
            }
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var sendButton: some View {
        Button {
            viewModel.sendMoney()
        } label: {
            
            HStack(spacing: 8) {
                if viewModel.isSending {
                    ProgressView()
                        .progressViewStyle(.circular)
                }

                Text(viewModel.isSending ? "Sending" : "Send")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                viewModel.isSendDisabled ? Color.gray.opacity(0.4) : Color.accentColor
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(viewModel.isSendDisabled)
    }
    
    private func errorText(_ message: String) -> some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(.red)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }


}
