//
//  MayaExamApp.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import SwiftUI
import SwiftData

@main
struct MayaExamApp: App {
    
    private let sharedModelContainer: ModelContainer
    private let initialModelContext: ModelContext

    /// Single source of truth of data
    @StateObject private var dataStore: DataStore

    /// Initializes SwiftData persistence and the shared app state.
    init() {
        let container = SwiftDataConfig.modelContainer
        let context = ModelContext(container)

        self.sharedModelContainer = container
        self.initialModelContext = context
        
        /// Inject the context into DataStore ensuring that data store will use
        /// only one model context and shared contaier
        _dataStore = StateObject(wrappedValue: DataStore(modelContext: context))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(dataStore)
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
