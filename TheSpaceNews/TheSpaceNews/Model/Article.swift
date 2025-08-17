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
}

struct Status: Decodable {
    let abbrev: String
    let name: String
}

struct ImageArticle: Decodable {
    let name: String
    let imageUrl: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image_url"
        case thumbnailUrl = "thumbnail_url"
    }
}
    
