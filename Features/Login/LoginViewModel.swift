//
//  LoginViewModel.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isLoggingIn: Bool = false
    
    private let genericError = "Something went wrong. Please try again."

    private var store: DataStore?
    
    var isLoginDisabled: Bool {
        return username.isEmpty || password.isEmpty || store == nil || isLoggingIn
    }
    
    /// Connects the view model to the shared DataStore
    func assignDataStore(_ store: DataStore) {
        self.store = store
    }

    /// Request authentication to DataStore using username and password
    func login() {
        
        guard let store else { return }
        
        isLoggingIn = true
        
        Task {
            
            // Always set to false after the auth task
            defer {
                isLoggingIn = false
            }
            
            do {
                try await store.authenticate(username: username, password: password)
                errorMessage = ""
                
            } catch let apiError as APIError {
                
                // APIError handling
                switch apiError {
                case .unauthorized:
                    errorMessage = apiError.errorDescription ?? genericError
                default:
                    errorMessage = genericError
                }
                
                showError = true
                
            } catch {
                errorMessage = genericError
                showError = true
            }

        }
        
    }
    
}
