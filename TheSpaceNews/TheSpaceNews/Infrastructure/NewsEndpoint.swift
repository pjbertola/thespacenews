//
//  NewsEndpoint.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//


import Foundation

struct NewsEndpoint {
    private let search: String
    init(with search: String? = nil) {
        self.search = search ?? String()
    }
    private var path: String {
        return "https://api.spaceflightnewsapi.net/v4/articles/?limit=50&ordering=-updated_at&search=\(search)"
    }

    var asURL: URL? {
        URL(string: path)
    }
}
