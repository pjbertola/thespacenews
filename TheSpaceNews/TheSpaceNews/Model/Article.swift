//
//  Article.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

struct Article: Decodable {
    let title: String
    let url: String
    let imageUrl: String
    let summary: String

    enum CodingKeys: String, CodingKey {
        case title
        case url
        case imageUrl = "image_url"
        case summary
        
    }
}

