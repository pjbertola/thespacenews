//
//  NewsList+ViewModel.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//
import Foundation
import SwiftUI

extension NewsListView {
    /// ViewModel for the NewsListView, managing news data, filtering, pagination, and navigation.
    @Observable
    class ViewModel {
        /// Handles navigation to detail views.
        private let coordinator: Coordinator = Coordinator()
        private let repository: NewsRepository
        var articles: [Article] = []
        var isLoading: Bool = true

        /// Initializes the ViewModel with a repository and filter.
        /// - Parameters:
        ///   - repository: The news repository to fetch articles from.
        init(repository: NewsRepository = SpaceNewsRepositoryDefault()) {
            self.repository = repository
        }

        /// Loads the latest articles and updates the error binding if needed.
        /// - Parameter viewError: Binding to set if an error occurs.
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

         /// Determines if more items should be loaded based on the current page and item.
         /// - Parameters:
         ///   - page: The current page number.
         ///   - item: The article currently being displayed.
         /// - Returns: The new page number if more items should be loaded.
        func loadMoreItemsIfNeeded(page: Int, currentItem item: Article) -> Int {
            guard page < 10 else {
                return page
            }
            return articles.last == item ? page + 1 : page
        }

        /// Loads more articles for pagination and updates the error binding if needed.
        /// - Parameter viewError: Binding to set if an error occurs.
        func loadMoreItems(viewError: Binding<Error?>) async {
            do {
                try await articles.append(contentsOf: repository.fetchNextArticles())
            } catch {
                viewError.wrappedValue = error
            }
            
        }
        /// Searches for articles matching the provided text and updates the error binding if needed.
        /// - Parameters:
        ///   - text: The search text.
        ///   - viewError: Binding to set if an error occurs.
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

        /// Returns the destination view for a given navigation data object.
        /// - Parameter data: The navigation data.
        /// - Returns: The destination view.
        func getDestination(data: NavigationData) -> some View {
            coordinator.getDestination(data: data)
        }
    }
}
