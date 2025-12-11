//
//  DashboardView.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var store: DataStore
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Top bar
                topBar
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // Dashboard card
                        DashboardCard(viewModel: viewModel)
                        
                        // UI Placeholder to fill the screen
                        DashboardFeaturePlaceholder()

                    }
                }
            }
            .padding()
            .task {
                viewModel.assignDataStore(store)
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            Text("Dashboard")
                .font(.title.bold())
            Spacer()
            Button("Logout") {
                store.logout()
            }
            .font(.subheadline.weight(.semibold))
        }
    }
    

}
