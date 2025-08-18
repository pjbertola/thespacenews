//
//  NewsListView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

struct NewsListView: View {
    var viewModel: ViewModel
    init(repository: NewsRepository = SpaceNewsRepositoryDefault()) {
        self.viewModel = ViewModel(repository: repository)
    }
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                List {
                    ForEach(viewModel.articles, id: \.self) { article in
                        NavigationLink(value: article) {
                            NewsRowView(article: article)
                        }
                    }
                }
                .navigationTitle("News Articles")
                .navigationDestination(for: Article.self) { article in
                    WebView(urlString: article.url)
                }
            }
        }.task {
            await viewModel.onAppear()
        }
    }
}

#Preview {
    NewsListView()
}
