//
//  URLRequestBuilder.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// Standard HTTP methods supported by the API layer.
enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

/// Abstraction for constructing URLRequest instances with base URL and HTTP methods.
/// This version only takes single endpoint but can be extended to support
/// - query
/// - dynamic headers
/// - JSON body
/// - multipart uploads, etc.
protocol URLRequestBuilder {
    func makeRequest(path: String, method: HTTPMethod) throws -> URLRequest
}


/// Default implementation of URLRequestBuilder used by the API layer.
struct DefaultURLRequestBuilder: URLRequestBuilder {
    
    let baseURL: URL?
    
    /// Initialize using baseURL, in this case using mock url
    init() {
        self.baseURL = AppConfig.default.apiBaseURL
    }
    
    init(baseURL: URL?) {
        self.baseURL = baseURL
    }

    /// Constructs a URLRequest using a base URL, API resource path and HTTP method.
    func makeRequest(
        path: String,
        method: HTTPMethod
    ) throws -> URLRequest {

        guard let baseURL else {
            throw RequestBuilderError.invalidBaseURL
        }
        
        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Future body or query encoding can be added here.
        // For demo purposes, we only construct the URL and HTTP method.

        return request
    }
}

enum RequestBuilderError: Error {
    case invalidBaseURL
}


