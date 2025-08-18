//
//  NewsListView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI

struct NewsListView: View {
    var viewModel: ViewModel
    @State private var searchText: String = ""
    @State private var page: Int = 0

    var filteredArticles: [Article] {
        viewModel.filterNews(text: searchText)
    }

    init(repository: NewsRepository = SpaceNewsRepositoryDefault()) {
        self.viewModel = ViewModel(repository: repository)
    }
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                List {
                    ForEach(filteredArticles, id: \.self) { article in
                        NavigationLink(value: article) {
                            NewsRowView(article: article)
                                .onAppear {
                                    page = viewModel.loadMoreItemsIfNeeded(page: page, currentItem: article)

                                }
                        }
                    }
                }
                .navigationTitle("News Articles")
                .searchable(text: $searchText)
                .navigationDestination(for: Article.self) { article in
                    WebView(urlString: article.url)
                }
                .refreshable {
                    await viewModel.refreshData()
                }
            }
        }.task {
            await viewModel.refreshData()
        }.task(id: page) {
            guard page > 0 else {
                return
            }
            await viewModel.loadMoreItems()
        }
    }
}

#Preview {
    NewsListView()
}
