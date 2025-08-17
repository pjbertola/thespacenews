//
//  SpaceNewsRepository.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

import Foundation

enum ServiceApiClient {
    case live
    case mock
    case invalidUrlMock
    case decodingErrorMock
}
enum DataError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError
}

protocol NewsArticlesRepository {
    func fetchArticles() async throws -> [Article]
    func fetchNextArticles() async throws -> [Article]
}
protocol NewsDetailsRepository {
    func fetchArticleDetails() async throws -> ArticleDetails
}

class SpaceNewsRepositoryDefault: NewsArticlesRepository {
    private let apiClient: ServiceApiClient
    private var nextURL: NextURL

    init(apiClient: ServiceApiClient = .live) {
        self.apiClient = apiClient
        self.nextURL = NextURL(apiClient: apiClient)
    }

    private func getURL() -> URL? {
        switch apiClient {
        case .live:
            return NewsEndpoint().asURL
        case .mock:
            return NewsMockEndpoint().asURL
        case .invalidUrlMock:
            return nil
        case .decodingErrorMock:
            return NewsMockEndpoint(path: "newsDecodingError.json").asURL
        }
    }
    private func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let urlRequest = URLRequest(url: url)
        var data: Data
        do {
            (data, _) = try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw DataError.networkError(error)
        }
        let decoder = JSONDecoder()
        do {
            let responseData = try decoder.decode(T.self, from: data)
            return responseData
        } catch {
            throw DataError.decodingError
        }

    }
    func fetchArticles() async throws -> [Article] {
        guard let url = getURL() else {
            throw DataError.invalidURL
        }
        do {
            let upcoming: Upcoming = try await fetchData(from: url)
            nextURL.updateNextURL(upcoming.next)
            return upcoming.results
        }
        catch {
            throw error
        }
    }
    
    func fetchNextArticles() async throws -> [Article] {
        guard let next = nextURL.getNextURL() else {
            return []
        }
        do {
            let upcoming: Upcoming =  try await fetchData(from: next)
            nextURL.updateNextURL(upcoming.next)
            return upcoming.results
        }
        catch {
            throw error
        }
    }
    
    func fetchArticleDetails(from url: URL?) async throws -> ArticleDetails {
        guard let url = url else {
            throw DataError.invalidURL
        }
        do {
            return try await fetchData(from: url)
        }
        catch {
            throw error
        }
    }
}

struct NewsEndpoint {
    private var path: String {
        let now = Date().formatedISO8601()
        let nextMonth = Date().addMonths(3).formatedISO8601()
        return "https://lldev.thespacedevs.com/2.3.0/launches/upcoming/?ordering=net&limit=10&mode=list&net__gte=\(now)&net__lte=\(nextMonth)"
    }

    var asURL: URL? {
        URL(string: path)
    }
}

struct NewsMockEndpoint {
    private let path: String

    init(path: String = "news.json") {
        self.path = path
    }

    var asURL: URL? {
        guard let file = Bundle.main.url(forResource: path, withExtension: nil)
        else {
            fatalError("Couldn't find \(path) in main bundle.")
        }
        return file
    }
}

fileprivate struct NextURL {
    private let apiClient: ServiceApiClient
    private var next: String?

    init(apiClient: ServiceApiClient = .live) {
        self.apiClient = apiClient
    }

    mutating func updateNextURL(_ url: String?) {
        self.next = url
    }

    func getNextURL() -> URL? {
        guard let nextURL = next else {
            return nil
        }
        switch apiClient {
        case .live:
            return URL(string: nextURL)
        case .mock:
            return NewsMockEndpoint(path: nextURL).asURL
        case .invalidUrlMock:
            return nil
        case .decodingErrorMock:
            return NewsMockEndpoint(path: "newsDecodingError.json").asURL
        }
    }
}
