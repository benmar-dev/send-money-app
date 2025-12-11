//
//  LocalAPIDataSource.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// Local implementation of APIDataSource. Instead of performing a real network call, this type resolves
/// requests into local `.json` files stored in the app bundle.
struct LocalAPIDataSource: APIDataSource {
    
    func data(fromURLRequest urlRequest: URLRequest) async throws -> Data {
        guard let url = urlRequest.url else {
            throw APIError.invalidURL
        }
        
        // JSON filename should be the path name
        // Example: "/transactions" -> "transactions.json"
        let path = url.path
        let fileName = path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        guard let fixtureURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw APIError.missingFile(fileName)
        }
        
        return try Data(contentsOf: fixtureURL)
    }
}
