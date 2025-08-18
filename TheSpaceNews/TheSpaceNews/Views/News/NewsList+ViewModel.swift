//
//  NewsList+ViewModel.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 18/08/2025.
//
import Foundation

extension NewsListView {
    @Observable
    class ViewModel {
        var articles: [Article] = []
        var repository: NewsRepository
        var filter: NewsFilter
        var isLoading: Bool = true
        var error: Error?

        init(repository: NewsRepository = SpaceNewsRepositoryDefault(),
             filter: NewsFilter = NewsFilterDefault()) {
            self.repository = repository
            self.filter = filter
        }

        func refreshData() async {
            do {
                isLoading = false
                articles = try await repository.fetchArticle()
                isLoading = false
            } catch {
                self.error = error
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
        func loadMoreItems() async {
            do {
                try await articles.append(contentsOf: repository.fetchNextArticles())
            } catch {
                self.error = error
            }
            
        }
        func searchNews(text: String) async {
            if text.isEmpty {
                await refreshData()
            } else {
                do {
                    isLoading = false
                    articles = try await repository.searchArticle(with: text)
                    isLoading = false
                } catch {
                    self.error = error
                }
            }
        }
    }
    
}
