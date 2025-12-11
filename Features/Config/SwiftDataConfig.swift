//
//  SwiftDataConfig.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import SwiftData

/// Centralizes all SwiftData configuration used by the app.
enum SwiftDataConfig {
    
    /// Declares every @Model type included in the persistence layer.
    static let allSchema = Schema([
        Transaction.self
    ])
    
    /// Defines a named local database using all schema.
    static var defaultConfig : ModelConfiguration {
        ModelConfiguration("DefaultDB", schema: allSchema)
    }
    
    /// Creates a shared ModelContainer instance
    static var modelContainer: ModelContainer {
        do {
            return try ModelContainer(for: allSchema, configurations: defaultConfig)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
}

extension SwiftDataConfig {
    
    /// Create a in-memory instance onf model container for Tests and previews
    static func makeMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: allSchema, configurations: config)
    }
    
}
