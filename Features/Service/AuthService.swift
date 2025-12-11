//
//  AuthService.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import Foundation
import CryptoKit

/// High-level API service for authentication.
class AuthService: APIService {
    
    /// Injected data source that determines how bytes are retrieved.
    let dataSource: any APIDataSource
    
    /// For the purpose of this demo, `AuthConfig` will store the valid username
    private let config = AuthConfig.load()

    /// Injected abstraction responsible for creating URLRequests.
    let requestBuilder: any URLRequestBuilder

    init(dataSource: any APIDataSource = RemoteAPIDataSource(),
         requestBuilder: any URLRequestBuilder = DefaultURLRequestBuilder()) {
        self.dataSource = dataSource
        self.requestBuilder = requestBuilder
    }
    
    /// Request authentication using username and password.
    /// Return a token for successful authentication
    func authenticate(username: String, password: String) async throws -> String {

        // If username is equal to the valid username stored in the `AuthConfig.xcconfig`,
        // append the username in the path
        let path = username == config.validUsername ? "/auth/\(username)" : "/auth"
        
        // Proceed if password is valid
        guard config.isValidPassword(password) else {
            throw APIError.unauthorized
        }
        
        let urlRequest = try requestBuilder.makeRequest(
            path: path,
            method: .POST
        )
        
        let response: AuthResponse = try await request(fromUrlRequest: urlRequest)
        return response.token
        
    }
    
}
