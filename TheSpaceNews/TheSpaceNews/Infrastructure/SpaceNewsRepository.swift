//
//  SpaceNewsRepository.swift
//  TheSpaceNews
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

import Foundation

enum ServiceApiClient: String {
    case live
    case mock
    case mockEmpty
    case invalidUrlMock
    case decodingErrorMock
    case networkErrorDetail
}
enum DataError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case networkErrorDetail(String)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError:
            return "Network Error"
        case .networkErrorDetail:
            return "Network Error"
        case .decodingError:
            return "Decoding Error"
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "It seems that the URL is not valid. Please check the URL and try again."
        case .networkError(let error):
            return error.localizedDescription
        case .networkErrorDetail(let detail):
            return "\(detail)"
        case .decodingError:
            return "The data received from the server could not be decoded. Please try again later."
        }
    }

}

protocol UpcomingRepository {
    func fetchLaunches() async throws -> [LaunchDetails]
    func fetchEvents() async throws -> [EventDetails]
    func clearCache()
}

protocol NewsRepository {
    func fetchArticle() async throws -> [Article]
    func fetchNextArticles() async throws -> [Article]
    func searchArticle(with search: String?) async throws -> [Article]
}

/// Default implementation of repositories for fetching space news, launches, and events.
/// Supports live and mock data sources, caching, and pagination.
class SpaceNewsRepositoryDefault: UpcomingRepository, NewsRepository {
    /// The API client type (live or various mock modes).
    private let apiClient: ServiceApiClient
    /// The URL session used for network requests.
    private let urlSession: URLSession
    /// Helper for managing pagination URLs for news articles.
    private var nextURL: NextURL
    /// Cached list of launch details.
    private var launches: [LaunchDetails] = []
    /// Cached list of event details.
    private var events: [EventDetails] = []

    /// Initializes the repository with a specified API client and URL session.
    /// - Parameters:
    ///   - apiClient: The API client to use (defaults to `.live`).
    ///   - urlSession: The URL session to use (defaults to `.shared`).
    init(apiClient: ServiceApiClient = .live, urlSession: URLSession = .shared) {
        self.apiClient = apiClient
        self.urlSession = urlSession
        self.nextURL = NextURL(apiClient: apiClient)
    }

    /// Fetches upcoming launches, using cache if available.
    /// - Returns: An array of `LaunchDetails`.
    func fetchLaunches() async throws -> [LaunchDetails] {
        if !launches.isEmpty {
            return launches
        }
        guard let url = getLaunchURL() else {
            try logAndThrow("Invalid URL for launches", error: DataError.invalidURL)
        }
        do {
            let upcoming: UpcomingLaunches = try await fetchData(from: url)
            launches = upcoming.results
            return upcoming.results
        }
        catch {
            try logAndThrow("Error fetching launches: \(error.localizedDescription)", error: error)
        }
    }

    /// Fetches upcoming events, using cache if available.
    /// - Returns: An array of `EventDetails`.
    func fetchEvents() async throws -> [EventDetails] {
        if !events.isEmpty {
            return events
        }
        guard let url = getEventURL() else {
            try logAndThrow("Invalid URL for events", error: DataError.invalidURL)
        }
        do {
            let upcoming: UpcomingEvents = try await fetchData(from: url)
            events = upcoming.results
            return upcoming.results
        }
        catch {
            try logAndThrow("Error fetching events: \(error.localizedDescription)", error: error)
        }
    }

    /// Clears cached launches and events.
    func clearCache() {
        launches = []
        events = []
    }

    /// Searches for news articles with an optional search string.
    /// - Parameter search: The search query.
    /// - Returns: An array of `Article`.
    func searchArticle(with search: String?) async throws -> [Article] {
        guard let url = getNewsURL(with: search) else {
            try logAndThrow("Invalid URL for news search", error: DataError.invalidURL)
        }
        do {
            let upcoming: NewsArticles = try await fetchData(from: url)
            nextURL.updateNextURL(upcoming.next)
            return upcoming.results
        }
        catch {
            try logAndThrow("Error fetching articles: \(error.localizedDescription)", error: error)
        }
    }

    /// Fetches the first page of news articles.
    /// - Returns: An array of `Article`.
    func fetchArticle() async throws -> [Article] {
        do {
            return try await searchArticle(with: nil)
        }
        catch {
            try logAndThrow("Error fetching launches: \(error.localizedDescription)", error: error)
        }
    }

    /// Fetches the next page of news articles using pagination.
    /// - Returns: An array of `Article`, or an empty array if no next page.
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
            try logAndThrow("Error fetching next articles: \(error.localizedDescription)", error: error)
        }
    }
}

private extension SpaceNewsRepositoryDefault {
    func getLaunchURL() -> URL? {
        switch apiClient {
        case .live:
            return LaunchEndpoint().asURL
        case .mock, .mockEmpty:
            return NewsMockEndpoint().asURL
        case .invalidUrlMock:
            return nil
        case .decodingErrorMock:
            return NewsMockEndpoint(path: "newsDecodingError.json").asURL
        case .networkErrorDetail:
            return NewsMockEndpoint(path: "networkError.json").asURL
        }
    }
    func getEventURL() -> URL? {
        switch apiClient {
        case .live:
            return EventEndpoint().asURL
        case .mock, .mockEmpty:
            return NewsMockEndpoint(path: "events.json").asURL
        case .invalidUrlMock:
            return nil
        case .decodingErrorMock:
            return NewsMockEndpoint(path: "newsDecodingError.json").asURL
        case .networkErrorDetail:
            return NewsMockEndpoint(path: "networkError.json").asURL
        }
    }
    func getNewsURL(with search: String? = nil) -> URL? {
        switch apiClient {
        case .live:
            return NewsEndpoint(with: search).asURL
        case .mock:
            return NewsMockEndpoint(path: "news.json").asURL
        case .mockEmpty:
            return NewsMockEndpoint(path: "newsEmpty.json").asURL
        case .invalidUrlMock:
            return nil
        case .decodingErrorMock:
            return NewsMockEndpoint(path: "newsDecodingError.json").asURL
        case .networkErrorDetail:
            return NewsMockEndpoint(path: "networkError.json").asURL
        }
    }
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let urlRequest = URLRequest(url: url)
        var data: Data
        do {
            (data, _) = try await urlSession.data(for: urlRequest)
        } catch {
            try logAndThrow("Network request failed", error: error)
        }
        let decoder = JSONDecoder()
        do {
            let responseData = try decoder.decode(T.self, from: data)
            return responseData
        } catch {
            do {
                let responseData = try decoder.decode(NetworkErrorDetail.self, from: data)
                try logAndThrow("Network error: \(responseData.detail)", error: DataError.networkErrorDetail(responseData.detail))
            } catch {
                if error is DataError {
                    try logAndThrow("Data error", error: error)
                } else {
                    try logAndThrow("Decoding error", error: DataError.decodingError)
                }
            }
        }
    }
    private func logAndThrow(_ message: String, error: Error) throws -> Never {
        print("\(message): \(error.localizedDescription)")
        throw error
    }
}

fileprivate class NextURL {
    private let apiClient: ServiceApiClient
    private var next: String?

    init(apiClient: ServiceApiClient = .live) {
        self.apiClient = apiClient
    }

    func updateNextURL(_ url: String?) {
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
        case .networkErrorDetail:
            return NewsMockEndpoint(path: "networkError.json").asURL
        case .mockEmpty:
            return NewsMockEndpoint(path: "newsEmpty.json").asURL
        }
    }
}
