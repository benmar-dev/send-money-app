//
//  APIService.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// High-level abstraction for performing API requests.
protocol APIService {
    
    /// Injected layer responsible for fetching resources location.
    /// Allows swapping between real, mock, or test data sources.
    var dataSource: any APIDataSource { get }
    
    /// Builder responsible for creating URLRequest instances
    var requestBuilder: any URLRequestBuilder { get }
    
    /// Decodes response into typed modelss
    var decoder: JSONDecoder { get }
    
    /// Execute the request from the data source
    func request<T: Decodable>(fromUrlRequest urlRequest: URLRequest) async throws -> T
}

extension APIService {
    
    /// Default JSON decoder used for transforming responses into typed models.
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    /// Executes a URLRequest using the injected APIDataSource and decodes the response into desired model types.
    func request<T: Decodable>(fromUrlRequest urlRequest: URLRequest) async throws -> T {
        let task = Task<T,Error> {
            let data = try await self.dataSource.data(fromURLRequest: urlRequest)
            return try self.decoder.decode(T.self, from: data)
        }
        
        return try await task.value
        
    }
    
}
