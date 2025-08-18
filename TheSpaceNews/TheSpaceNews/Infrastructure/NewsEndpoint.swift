//
//  NewsEndpoint.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//


import Foundation

struct NewsEndpoint {
    private var path: String {
        return "https://api.spaceflightnewsapi.net/v4/articles/?limit=50&ordering=-updated_at"
    }

    var asURL: URL? {
        URL(string: path)
    }
}
