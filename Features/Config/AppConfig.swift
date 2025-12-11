//
//  AppConfig.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/11/25.
//

import Foundation

/// Global application configuration for environment-level settings.
/// Used for injecting constants such as default wallet balance,
/// feature flags, etc.
struct AppConfig {
    let initialBalance: Decimal
    let apiBaseURL: URL?
    
    // Add more config values here as needed.
    
    static let `default` = AppConfig(
        initialBalance: 1000,
        apiBaseURL: URL(string: "https://e59e7321-c639-40af-a0a5-9eb43f7bfcb1.mock.pstmn.io")
    )
}
