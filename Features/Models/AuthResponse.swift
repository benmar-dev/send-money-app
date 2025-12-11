//
//  AuthResponse.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

/// Success response from authentication that contains a token
struct AuthResponse: Codable {
    let token: String
}
