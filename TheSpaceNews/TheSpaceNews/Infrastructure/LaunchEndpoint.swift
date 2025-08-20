//
//  LaunchEndpoint.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

import Foundation

/// The endpoint fetches events after the current date, limited to 3 results, ordered by date.
struct LaunchEndpoint {
    private var path: String {
        let now = Date().formatedISO8601()
        return "https://lldev.thespacedevs.com/2.3.0/launches/upcoming/?ordering=net&limit=3&mode=detailed&net__gte=\(now)"
    }

    var asURL: URL? {
        URL(string: path)
    }
}
