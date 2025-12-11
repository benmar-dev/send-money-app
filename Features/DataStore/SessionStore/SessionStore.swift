//
//  SessionStore.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/11/25.
//

import Foundation

/// A storage abstraction responsible for persisting and retrieving the
/// authenticated user's session token.
///
/// - `saveToken(_:)`  Persists the authentication token.
/// - `loadToken()`    Retrieves the previously saved token, if any.
/// - `clearToken()`   Removes the stored token when the user logs out.
protocol SessionStore {
    func saveToken(_ token: String) throws
    func loadToken() throws -> String?
    func clearToken() throws
}
