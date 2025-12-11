//
//  MockAPIDataSource.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation
@testable import MayaExam

struct MockAPIDataSource: APIDataSource {
    
    enum Mode {
        case success(Data)
        case failure(Error)
    }

    let mode: Mode
    
    func data(fromURLRequest urlRequest: URLRequest) async throws -> Data {
        switch mode {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }

    }

}
