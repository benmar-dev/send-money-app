//
//  KeychainSession.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import Foundation
import Security

/// The concrete implementation of `SessionStore` that uses Keychains as storage.
/// For this demo, we are only saving a single token without expiration date.
struct KeychainSession: SessionStore {
    
    private static let service = "MayaExam.Auth"
    private static let account = "authToken"
    
    /// Saves a token into the Keychain.
    func saveToken(_ token: String) throws {
        let data = Data(token.utf8)
        
        // Remove existing token before writing a new one.
        try? clearToken()
        
        let query: [String: Any] = [
            kSecClass as String:  kSecClassGenericPassword,
            kSecAttrService as String: Self.service,
            kSecAttrAccount as String: Self.account,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed
        }
    }
    
    /// Loads the token from Keychain.
    func loadToken() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.service,
            kSecAttrAccount as String: Self.account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecItemNotFound {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.loadFailed
        }
        
        // Convert stored data back to string.
        guard let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    /// Removes the stored token from Keychain.
    func clearToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.service,
            kSecAttrAccount as String: Self.account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecItemNotFound { return }
        
        guard status == errSecSuccess else {
            throw KeychainError.deleteFailed
        }
    }
}

enum KeychainError: Error {
    case saveFailed
    case loadFailed
    case deleteFailed
}
