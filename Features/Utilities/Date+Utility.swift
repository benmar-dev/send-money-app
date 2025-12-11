//
//  Date+Utility.swift
//  MayaExam
//
//  Created by Alvin Marana on 12/10/25.
//

import Foundation

extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
