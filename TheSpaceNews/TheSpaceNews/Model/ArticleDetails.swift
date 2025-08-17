//
//  ArticleDetails.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

struct ArticleDetails: Decodable {
    let id: String
    let name: String
    let image: ImageArticle
    let status: Status
    let net: String
}

struct Mission: Decodable {
    let id: String
    let description: String
}
