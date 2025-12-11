//
//  RemoteAPIDataSource.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// Concrete APIDataSource that use URLSession.
/// Responsible for executing URLRequests and returning raw response Data.
struct RemoteAPIDataSource: APIDataSource {
    
    func data(fromURLRequest urlRequest: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Validate the response is HTTP and has a 2xx status code
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                switch httpResponse.statusCode {
                case 401:
                    throw APIError.unauthorized
                default:
                    throw APIError.statusCode(httpResponse.statusCode)
                }
            }
            return data

        } catch let apiError as APIError {
            throw apiError
        } catch let error as URLError {
            throw APIError.network(error)
        } catch {
            throw APIError.unknown(error)
        }
    }
}
