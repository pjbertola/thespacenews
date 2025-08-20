//
//  Date+Functions.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 16/08/2025.
//

import Foundation

extension Date {
    func formatedISO8601() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    func addMonths(_ amount: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: amount, to: self) ?? self
    }

    /// Returns a string representation of the date in the format "MMM dd, yyyy HH:mm:ss"
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    static func fromFormattedISO8601(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
}
