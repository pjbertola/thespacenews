//
//  EventEndpoint.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

import Foundation

/// The endpoint fetches events after the current date, limited to 3 results, ordered by date.
struct EventEndpoint {
    private var path: String {
        let now = Date().formatedISO8601()
        return "https://ll.thespacedevs.com/2.3.0/events/?limit=3&ordering=date&date__gt=\(now)"
    }

    var asURL: URL? {
        URL(string: path)
    }
}
