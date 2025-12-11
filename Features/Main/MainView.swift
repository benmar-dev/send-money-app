//
//  MainView.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import SwiftUI
import CryptoKit

/// The root view of the app that switches between the login flow
/// and the authenticated dashboard.
struct MainView: View {
    
    @EnvironmentObject private var store: DataStore
    
    var body: some View {
        ZStack {
            if store.isAuthenticated {
                DashboardView()
            } else {
                LoginView()
            }
        }
    }
    
}
