//
//  WalletService.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// High-level API service for wallet-related operations.
class WalletService: APIService {
    
    /// Injected data source that determines how bytes are retrieved.
    let dataSource: any APIDataSource
    
    /// Injected abstraction responsible for creating URLRequests.
    let requestBuilder: any URLRequestBuilder

    init(dataSource: any APIDataSource = RemoteAPIDataSource(),
         requestBuilder: any URLRequestBuilder = DefaultURLRequestBuilder()) {
        self.dataSource = dataSource
        self.requestBuilder = requestBuilder
    }
    
    /// Fetches wallet transactions using the injected request builder and data source.
    func fetchTransactionHistory() async throws -> [TransactionDTO]  {
        let urlRequest = try requestBuilder.makeRequest(
            path: "/transactions",
            method: .GET
        )
        return try await request(fromUrlRequest: urlRequest)
    }
    
}

