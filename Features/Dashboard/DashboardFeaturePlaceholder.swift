//
//  DashboardFeaturePlaceholder.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/9/25.
//

import SwiftUI

struct DashboardFeaturePlaceholder: View {
    var body: some View {
        featureGridCell(text: "PLACEHOLDER")

        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
            ForEach(0..<12) { _ in
                featureGridCell()
            }
        }
        .padding(.top, 4)

        featureGridCell()

    }
    
    private func featureGridCell(text: String? = nil) -> some View {
        VStack(spacing: 6) {
            if let text {
                Text(text)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity, minHeight: 72)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

}
