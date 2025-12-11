//
//  DataStore_Auth_Tests.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import XCTest
@testable import MayaExam

class DataStore_Auth_Tests: XCTestCase {
    
    @MainActor
    func test_authenticate_success() async throws {
        // GIVEN
        let expectedToken = "ABC"
        let json = """
        { "token": "\(expectedToken)" }
        """.data(using: .utf8)!

        let tokenStore = FakeTokenStore()
        let mockDataSource = MockAPIDataSource(mode: .success(json))
        let auth = AuthService(dataSource: mockDataSource)
        let store = DataStore(authService: auth, sessionStore: tokenStore)

        // WHEN
        try await store.authenticate(username: "username", password: "password")

        // THEN
        XCTAssertTrue(store.isAuthenticated)
    }
    
    @MainActor
    func test_authenticate_unauthorized() async {
        // GIVEN
        let mockDataSource = MockAPIDataSource(
            mode: .failure(APIError.unauthorized)
        )
        let auth = AuthService(dataSource: mockDataSource)
        let tokenStore = FakeTokenStore()
        let store = DataStore(authService: auth, sessionStore: tokenStore)

        // WHEN + THEN
        do {
            try await store.authenticate(username: "username", password: "password")
            XCTFail("Expected unauthorized error")
        } catch let apiError as APIError {
            XCTAssertEqual(
                apiError.errorDescription,
                APIError.unauthorized.errorDescription
            )
            XCTAssertFalse(store.isAuthenticated)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    @MainActor
    func test_logout_sets_isAuthenticated_false() async throws {
        // GIVEN
        let expectedToken = "ABC"
        let json = """
        { "token": "\(expectedToken)" }
        """.data(using: .utf8)!

        let mockDataSource = MockAPIDataSource(mode: .success(json))
        let auth = AuthService(dataSource: mockDataSource)
        let tokenStore = FakeTokenStore()
        let store = DataStore(authService: auth, sessionStore: tokenStore)

        try await store.authenticate(username: "username", password: "password")
        XCTAssertTrue(store.isAuthenticated)

        // WHEN
        store.logout()

        // THEN
        XCTAssertFalse(store.isAuthenticated)
    }

    @MainActor
    func test_loadSession_whenTokenExists() throws {
        // GIVEN
        let tokenStore = FakeTokenStore()
        try tokenStore.saveToken("ABC")
        let store = DataStore(sessionStore: tokenStore)

        // WHEN
        store.loadSession()

        // THEN
        XCTAssertTrue(store.isAuthenticated)
    }
    
    @MainActor
    func test_loadSession_whenNoToken() throws {
        // GIVEN: empty token
        let tokenStore = FakeTokenStore()
        let store = DataStore(sessionStore: tokenStore)

        // WHEN
        store.loadSession()

        // THEN
        XCTAssertFalse(store.isAuthenticated)
    }

    
}
