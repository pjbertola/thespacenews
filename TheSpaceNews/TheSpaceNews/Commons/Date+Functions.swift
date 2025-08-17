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
//        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
    func addMonths(_ amount: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: amount, to: self) ?? self
    }
}
