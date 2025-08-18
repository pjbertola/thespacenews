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
enum DataError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError:
            return "Decoding Error"
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Retry later"
        case .networkError:
            return "Retry later"
        case .decodingError:
            return "Retry later"
        }
    }

}

protocol UpcomingRepository {
    func fetchLaunches() async throws -> [LaunchDetails]
    func fetchEvents() async throws -> [EventDetails]
}

protocol NewsRepository {
    func fetchArticle() async throws -> [Article]
    func fetchNextArticles() async throws -> [Article]
    func searchArticle(with search: String?) async throws -> [Article]
}

class SpaceNewsRepositoryDefault: UpcomingRepository, NewsRepository {
    private let apiClient: ServiceApiClient
    private var nextURL: NextURL

    init(apiClient: ServiceApiClient = .live) {
        self.apiClient = apiClient
        self.nextURL = NextURL(apiClient: apiClient)
    }

    func fetchLaunches() async throws -> [LaunchDetails] {
        guard let url = getLaunchURL() else {
            throw DataError.invalidURL
        }
        do {
            let upcoming: UpcomingLaunches = try await fetchData(from: url)
            return upcoming.results
        }
        catch {
            print("Error fetching launches: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchEvents() async throws -> [EventDetails] {
        guard let url = getEventURL() else {
            throw DataError.invalidURL
        }
        do {
            let upcoming: UpcomingEvents = try await fetchData(from: url)
            return upcoming.results
        }
        catch {
            print("Error fetching launches: \(error.localizedDescription)")
            throw error
        }
    }
    func searchArticle(with search: String?) async throws -> [Article] {
        guard let url = getNewsURL(with: search) else {
            throw DataError.invalidURL
        }
        do {
            let upcoming: NewsArticles = try await fetchData(from: url)
            nextURL.updateNextURL(upcoming.next)
            return upcoming.results
        }
        catch {
            print("Error fetching launches: \(error.localizedDescription)")
            throw error
        }
    }
    func fetchArticle() async throws -> [Article] {
        do {
            return try await searchArticle(with: nil)
        }
        catch {
            print("Error fetching launches: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchNextArticles() async throws -> [Article] {
        guard let next = nextURL.getNextURL() else {
            return []
        }
        do {
            let upcoming: NewsArticles =  try await fetchData(from: next)
            nextURL.updateNextURL(upcoming.next)
            return upcoming.results
        }
        catch {
            print("Error fetching launches: \(error.localizedDescription)")
            throw error
        }
    }
}

private extension SpaceNewsRepositoryDefault {
    func getLaunchURL() -> URL? {
        switch apiClient {
        case .live:
            return LaunchEndpoint().asURL
        case .mock:
            return NewsMockEndpoint().asURL
        case .invalidUrlMock:
            return nil
        case .decodingErrorMock:
            return NewsMockEndpoint(path: "newsDecodingError.json").asURL
        }
    }
    func getEventURL() -> URL? {
        switch apiClient {
        case .live:
            return EventEndpoint().asURL
        case .mock:
            return NewsMockEndpoint(path: "events.json").asURL
        case .invalidUrlMock:
            return nil
        case .decodingErrorMock:
            return NewsMockEndpoint(path: "newsDecodingError.json").asURL
        }
    }
    func getNewsURL(with search: String? = nil) -> URL? {
        switch apiClient {
        case .live:
            return NewsEndpoint(with: search).asURL
        case .mock:
            return NewsMockEndpoint(path: "news.json").asURL
        case .invalidUrlMock:
            return nil
        case .decodingErrorMock:
            return NewsMockEndpoint(path: "newsDecodingError.json").asURL
        }
    }
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
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
