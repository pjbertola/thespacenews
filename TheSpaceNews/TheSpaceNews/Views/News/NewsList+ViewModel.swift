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
        var isLoading: Bool = true
        var error: Error?

        init(repository: NewsRepository = SpaceNewsRepositoryDefault()) {
            self.repository = repository
        }

        func onAppear() async {
            do {
                articles = try await repository.fetchArticle()
                isLoading = false
            } catch {
                self.error = error
            }
        }
    }
    
}
