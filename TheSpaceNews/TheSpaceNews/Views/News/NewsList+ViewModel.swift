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

        func onAppear() async {
            do {
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
    }
    
}
