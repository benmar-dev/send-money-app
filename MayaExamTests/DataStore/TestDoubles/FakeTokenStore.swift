//
//  FakeTokenStore.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

@testable import MayaExam

class FakeTokenStore: SessionStore {
    private(set) var savedToken: String?

    func saveToken(_ token: String) throws {
        savedToken = token
    }

    func loadToken() throws -> String? {
        return savedToken
    }

    func clearToken() throws {
        savedToken = nil
    }
}
