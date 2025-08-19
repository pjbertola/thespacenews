//
//  EventDetails.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

struct EventDetails: Decodable, Hashable, NavigationData {
    let name: String
    let image: ImageArticle
    let date: String
    let description: String
}
