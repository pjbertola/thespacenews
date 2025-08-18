//
//  ArticleDetails.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

struct LaunchDetails: Decodable {
    let name: String
    let image: ImageArticle
    let status: Status
    let net: String
    let mission: Mission
}

struct Mission: Decodable {
    let description: String
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
    
