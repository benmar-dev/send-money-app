//
//  APIError.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// Represents all possible API-related failures for the network layer.
/// This error type unifies both remote (HTTP/network) and local (mocking)
/// failure cases into a single, strongly-typed surface area for the app.
///
/// Cases include:
/// - `network`        : Underlying `URLError` for connectivity issues.
/// - `statusCode`     : Non-2xx HTTP responses without a server-provided message.
/// - `serverError`    : Error responses that return a status code with a readable message.
/// - `unknown`        : Any unexpected error type passed through the pipeline.
/// - `invalidResponse`: Missing or malformed HTTP data.
/// - `decodingFailed` : JSON decoding failures (invalid or mismatched schema).
/// - `unauthorized`   : Authentication / login failures.
///
/// Local/mock cases:
/// - `invalidURL`     : When mapping a request to a local stub/fixture fails.
/// - `missingFile`    : When a local JSON file cannot be found in the bundle.
///
/// Each error provides a user-friendly `errorDescription` via `LocalizedError`.
enum APIError: Error, LocalizedError {
    case network(URLError)
    case statusCode(Int)
    case serverError(status: Int, message: String)
    case unknown(Error)
    case invalidResponse
    case decodingFailed
    case unauthorized
    
    // Local
    case invalidURL
    case missingFile(String)

    var errorDescription: String? {
        switch self {
        case .network(let err):
            return "Network error: \(err.localizedDescription)"
        case .statusCode(let code):
            return "HTTP error: \(code)"
        case .serverError(_, let message):
            return "Server error: \(message)"
        case .unknown(let err):
            return "Unknown error: \(err.localizedDescription)"
        case .invalidResponse:
            return "The response was invalid or missing expected content."
        case .decodingFailed:
            return "Failed to decode the itinerary data. The response may be malformed."
        case .invalidURL:
            return "Unable to map the request to a local fixture file. The URL is invalid or unsupported."
        case .missingFile(let fileName):
            return "Local file '\(fileName).json' could not be found in the app bundle."
        case .unauthorized:
            return "Invalid username or password."

        }
    }

}
