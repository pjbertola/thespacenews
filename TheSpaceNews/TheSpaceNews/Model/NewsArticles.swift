//
//  NewsArticles.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

struct NewsArticles: Decodable {
    let next: String?
    let results: [Article]
}
