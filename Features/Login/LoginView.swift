//
//  LoginView.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var store: DataStore
    @StateObject private var viewModel = LoginViewModel()
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                title
                
                textFields
                
                loginButton
                
                Spacer()
            }
            .padding()
            .task {
                viewModel.assignDataStore(store)
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
                Button("OK") { }
            }
        }
    }
    
    private var title: some View {
        VStack(spacing: 8) {
            Text("Log in to continue")
                .font(.largeTitle.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 24)
    }
    
    private var textFields: some View {
        VStack(spacing: 16) {
            TextField("Username", text: $viewModel.username)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled(viewModel.isLoggingIn)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled(viewModel.isLoggingIn)
        }
    }
    
    private var loginButton: some View {
        Button {
            viewModel.login()
        } label: {
            HStack(spacing: 8) {
                if viewModel.isLoggingIn {
                    ProgressView()
                        .progressViewStyle(.circular)
                }

                Text(viewModel.isLoggingIn ? "Logging in..." : "Login")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                viewModel.isLoginDisabled ? Color.gray.opacity(0.4) : Color.accentColor
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(viewModel.isLoginDisabled)
        .padding(.top, 8)
    }
    
}
