//
//  NewsList+ViewModel.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//
import Foundation
import SwiftUI

extension NewsListView {
    @Observable
    class ViewModel {
        var articles: [Article] = []
        var repository: NewsRepository
        var filter: NewsFilter
        var isLoading: Bool = true

        init(repository: NewsRepository = SpaceNewsRepositoryDefault(),
             filter: NewsFilter = NewsFilterDefault()) {
            self.repository = repository
            self.filter = filter
        }

        func refreshData(viewError: Binding<Error?>) async {
            do {
                isLoading = true
                articles = try await repository.fetchArticle()
                isLoading = false
            } catch {
                isLoading = false
                viewError.wrappedValue = error
            }
        }
        func filterNews(text: String) -> [Article] {
            if text.isEmpty {
                return articles
            } else {
                return filter.filter(articles: articles, text: text)
            }
        }
        func loadMoreItemsIfNeeded(page: Int, currentItem item: Article) -> Int {
            guard page < 10 else {
                return page
            }
            return articles.last == item ? page + 1 : page
        }
        func loadMoreItems(viewError: Binding<Error?>) async {
            do {
                try await articles.append(contentsOf: repository.fetchNextArticles())
            } catch {
                viewError.wrappedValue = error
            }
            
        }
        func searchNews(text: String, viewError: Binding<Error?>) async {
            do {
                isLoading = true
                articles = try await repository.searchArticle(with: text)
                isLoading = false
            } catch {
                isLoading = false
                viewError.wrappedValue = error
            }
        }
    }
}
