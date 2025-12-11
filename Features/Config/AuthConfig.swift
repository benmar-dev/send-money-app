//
//  AuthConfig.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import Foundation
import CryptoKit

/// Holds the credentials included in the bundle loaded from Info.plist
struct AuthConfig {
    
    /// Fixed credentials inside the AuthConfig.xcconfig
    let validUsername: String
    let validPassword: String
    
    /// Loads values from Info.plist, with the following keys.
    /// AUTH_USERNAME for username
    /// AUTH_PASSWORD_HASH for password hash
    static func load() -> AuthConfig {
        
        let bundle = Bundle.main
        
        guard let username = bundle.object(forInfoDictionaryKey: "AUTH_USERNAME") as? String,
              let password = bundle.object(forInfoDictionaryKey: "AUTH_PASSWORD_HASH") as? String else {
            fatalError("Username and password not found in bundle")
        }
        
        return AuthConfig(validUsername: username, validPassword: password)
    }
    
    /// Checks the entered password if equal to valid password inside the `AuthConfig.xcconfig`
    func isValidPassword(_ password: String) -> Bool {
        let passwordHash = Self.hash(password)
        return passwordHash == validPassword
    }
    
}

extension AuthConfig {
    /// Hashes a plaintext string to a SHA-256 hex string.
    private static func hash(_ string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
