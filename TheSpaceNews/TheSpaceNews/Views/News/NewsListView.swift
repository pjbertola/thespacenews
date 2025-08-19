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
    @State private var error: Error?

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
                    if viewModel.articles.isEmpty,
                       !viewModel.isLoading {
                        Text("No results for \"\(callText)\"")
                    } else {
                        ForEach(viewModel.articles, id: \.self) { article in
                            NavigationLink(value: article) {
                                NewsRowView(article: article)
                                    .onAppear {
                                        page = viewModel.loadMoreItemsIfNeeded(page: page, currentItem: article)
                                        
                                    }
                                    .accessibilityIdentifier("NewsRowView")
                            }
                        }
                    }
                }
                .accessibilityIdentifier("ListNews")
                .padding()
                .navigationDestination(for: Article.self) { article in
                    viewModel.getDestination(data: article)
                }
                .refreshable {
                    Task {
                        await viewModel.refreshData(viewError: $error)
                    }
                }
                .navigationTitle("News Articles")
                .errorAlert(error: $error) {
                    Task {
                        await viewModel.refreshData(viewError: $error)
                    }
                }
            }
        }.task {
            await viewModel.refreshData(viewError: $error)
        }.task(id: page) {
            guard page > 0 else {
                return
            }
            await viewModel.loadMoreItems(viewError: $error)
        }
        .task(id: callText) {
            await viewModel.searchNews(text: callText, viewError: $error)
        }
    }
}

#Preview {
    NewsListView()
}
