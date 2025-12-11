//
//  APIDataSource.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// Abstraction for retrieving raw Data for a given URLRequest.
protocol APIDataSource {
    func data(fromURLRequest urlRequest: URLRequest) async throws -> Data
}
