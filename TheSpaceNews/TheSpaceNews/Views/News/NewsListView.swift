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
    @State private var callText: String = ""

    init(repository: NewsRepository = SpaceNewsRepositoryDefault()) {
        self.viewModel = ViewModel(repository: repository)
    }
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                HStack {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button (action: {
                        callText = searchText
                    }){
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding()
                List {
                    ForEach(viewModel.articles, id: \.self) { article in
                        NavigationLink(value: article) {
                            NewsRowView(article: article)
                                .onAppear {
                                    page = viewModel.loadMoreItemsIfNeeded(page: page, currentItem: article)

                                }
                        }
                    }
                }
                .padding()
                .navigationDestination(for: Article.self) { article in
                    WebView(urlString: article.url)
                }
                .refreshable {
                    await viewModel.refreshData()
                }
                .navigationTitle("News Articles")
            }
        }.task {
            await viewModel.refreshData()
        }.task(id: page) {
            guard page > 0 else {
                return
            }
            await viewModel.loadMoreItems()
        }
        .task(id: callText) {
            await viewModel.searchNews(text: callText)
        }
    }
}

#Preview {
    NewsListView()
}
