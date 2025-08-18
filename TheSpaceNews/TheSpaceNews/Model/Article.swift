//
//  Article.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

struct Article: Decodable {
    let id: String
    let url: String
    let name: String
    let status: Status
    let net: String
    let image: ImageArticle
}

