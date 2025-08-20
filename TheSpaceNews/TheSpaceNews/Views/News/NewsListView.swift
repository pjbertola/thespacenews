//
//  NewsListView.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//

import SwiftUI
/// A view that displays a searchable, paginated list of news articles.
struct NewsListView: View {
    var viewModel: ViewModel
    /// The current text in the search field.
    @State private var searchText: String = ""
    /// The current page for pagination.
    @State private var page: Int = 0
    /// The text used to trigger a search.
    @State private var callText: String = ""
    /// Holds any error encountered during data loading.
    @State private var error: Error?

    /// Initializes the view with a news repository.
    /// - Parameter repository: The repository to fetch news from.
    init(repository: NewsRepository = SpaceNewsRepositoryDefault()) {
        self.viewModel = ViewModel(repository: repository)
    }
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                // Search bar and search button.
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
                // List of articles or a message if no results.
                List {
                    if viewModel.articles.isEmpty,
                       !viewModel.isLoading {
                        Text("No results for \"\(callText)\"")
                    } else {
                        ForEach(viewModel.articles, id: \.self) { article in
                            NavigationLink(value: article) {
                                NewsRowView(article: article)
                                    .onAppear {
                                        // Load more items when the last item appears.
                                        page = viewModel.loadMoreItemsIfNeeded(page: page, currentItem: article)
                                        
                                    }
                                    .accessibilityIdentifier("NewsRowView")
                            }
                        }
                    }
                }
                .accessibilityIdentifier("ListNews")
                .padding()
                // Navigation to article details.
                .navigationDestination(for: Article.self) { article in
                    viewModel.getDestination(data: article)
                }
                // Pull-to-refresh support.
                .refreshable {
                    page = 0
                    Task {
                        await viewModel.refreshData(viewError: $error)
                    }
                }
                .navigationTitle("News Articles")
                // Error alert handling.
                .errorAlert(error: $error) {
                    Task {
                        await viewModel.refreshData(viewError: $error)
                    }
                }
            }
        }
        // Initial data load.
        .task {
            await viewModel.refreshData(viewError: $error)
        }
        // Load more items when the page changes.
        .task(id: page) {
            guard page > 0 else {
                return
            }
            await viewModel.loadMoreItems(viewError: $error)
        }
        // Perform search when the search text changes.
        .task(id: callText) {
            await viewModel.searchNews(text: callText, viewError: $error)
        }
    }
}

#Preview {
    NewsListView()
}
