//
//  DataStore+Auth.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import Foundation

extension DataStore {
    
    /// Logout the current session
    func logout() {
        isAuthenticated = false
        try? sessionStore.clearToken()
    }
    
    /// Load current session if possible
    func loadSession() {
        // If a token exists in Keychain, treat the user as authenticated
        isAuthenticated = (try? sessionStore.loadToken()) != nil
    }

    /// Request authentication to AuthService using username and password
    /// Save the token to keychains after successful login
    func authenticate(username: String, password: String) async throws {
        do {
            let token = try await authService.authenticate(username: username, password: password)
            isAuthenticated = true
            try? sessionStore.saveToken(token)
        }
    }
    
}
