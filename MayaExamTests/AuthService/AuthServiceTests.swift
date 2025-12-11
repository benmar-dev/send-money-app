//
//  AuthServiceTests.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import XCTest
@testable import MayaExam

final class AuthServiceTest: XCTestCase {
    
    func test_authenticate_success_returnsToken() async throws {
        
        let expectedToken = "ABC"

        let json = """
        { "token": "\(expectedToken)" }
        """.data(using: .utf8)!
        
        // GIVEN
        let mockDataSource = MockAPIDataSource(
            mode: .success(json)
        )
                
        // WHEN
        let auth = AuthService(dataSource: mockDataSource)
        
        // THEN
        let token = try await auth.authenticate(username: "demo", password: "pass")
        XCTAssertEqual(token, expectedToken)
    }
    
    func test_authenticate_unauthorized_throwsError() async {
        
        // GIVEN
        let mockDataSource = MockAPIDataSource(
            mode: .failure(APIError.unauthorized)
        )

        // WHEN
        let auth = AuthService(dataSource: mockDataSource)

        // THEN
        do {
            _ = try await auth.authenticate(username: "wrong", password: "wrong")
            XCTFail("Expected unauthorized error")
        } catch let apiError as APIError {
            XCTAssertEqual(
                apiError.errorDescription,
                APIError.unauthorized.errorDescription
            )
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    
}
