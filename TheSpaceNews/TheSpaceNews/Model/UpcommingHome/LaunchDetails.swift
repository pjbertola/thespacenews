//
//  ArticleDetails.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

import Foundation

struct LaunchDetails: Decodable, Hashable, NavigationData {
    let name: String
    let image: ImageArticle
    let status: Status
    let net: String
    let mission: Mission
}

struct Mission: Decodable, Hashable {
    let description: String
}

struct Status: Decodable, Hashable {
    let abbrev: String
    let name: String
}

struct ImageArticle: Decodable, Hashable {
    let name: String
    let imageUrl: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image_url"
        case thumbnailUrl = "thumbnail_url"
    }
}
    
