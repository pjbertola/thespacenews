//
//  NewsFilter.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//


protocol NewsFilter {
    func filter(articles: [Article], text: String) -> [Article]
}
struct NewsFilterDefault: NewsFilter {
    func filter(articles: [Article], text: String) -> [Article] {
        articles.filter {
            $0.title.lowercased().contains(text.lowercased())
            || $0.imageUrl.lowercased().contains(text.lowercased())
            || $0.summary.lowercased().contains(text.lowercased())
        }
    }
}
