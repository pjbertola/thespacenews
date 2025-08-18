//
//  NewsRowView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

struct NewsRowView: View {
    var article: Article
    var body: some View {
        HStack {
            AsyncImage(url: URL(string:article.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            Text(article.title)
                .bold()
        }
    }
}

#Preview {
    let article = Article(
        title: "Countdown To Launch : What to Expect From Starship Flight 10",
        url: "https://tlpnetwork.com/news/america/countdown-to-launch-what-to-expect-from-starship-flight-10",
        imageUrl: "https://cdn.tlpnetwork.com/articles/2025/1755474284234.jpeg",
        summary: "Countdown To Launch : What to Expect From Starship Flight 10"
    )
    NewsRowView(article: article)
}
