//
//  NewsMockEndpoint.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//
import Foundation

/// Returns the URL of the local JSON file in the main bundle.
struct NewsMockEndpoint {
    private let path: String

    init(path: String = "launches.json") {
        self.path = path
    }

    var asURL: URL? {
        guard let file = Bundle.main.url(forResource: path, withExtension: nil)
        else {
            fatalError("Couldn't find \(path) in main bundle.")
        }
        return file
    }
}
