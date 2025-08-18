//
//  SpaceNewsRepositoryTests.swift
//  TheSpaceNewsTests
//
//  Created by Pablo J. Bertola on 17/08/2025.
//

import XCTest
@testable import TheSpaceNews

class SpaceNewsRepositoryTests: XCTestCase {
    var repository: SpaceNewsRepositoryDefault!
    
    override func setUp() {
        //given
        repository = SpaceNewsRepositoryDefault(apiClient: .mock)
    }

    func testFetchLaunches() async {
        // when
        let articles = try! await repository.fetchLaunches()
        // then
        XCTAssertTrue(articles.count == 3)
    }

    func testFetchEventes() async {
        // when
        let articles = try! await repository.fetchEvents()
        // then
        XCTAssertTrue(articles.count == 3)
    }

    func testFetchLaunchesInvalidURL() async {
        repository = SpaceNewsRepositoryDefault(apiClient: .invalidUrlMock)
        // when
        do {
            let articles = try await repository.fetchLaunches()
            print(articles.count)
        } catch DataError.invalidURL {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected DataError.invalidURL but got \(error)")
        }
    }

    func testFetchLaunchesDecodingError() async {
        repository = SpaceNewsRepositoryDefault(apiClient: .decodingErrorMock)
        // when
        do {
            let articles = try await repository.fetchLaunches()
            print(articles.count)
        } catch DataError.decodingError {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected DataError.decodingError but got \(error)")
        }
    }
    func testFetchEventsInvalidURL() async {
        repository = SpaceNewsRepositoryDefault(apiClient: .invalidUrlMock)
        // when
        do {
            let articles = try await repository.fetchEvents()
            print(articles.count)
        } catch DataError.invalidURL {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected DataError.invalidURL but got \(error)")
        }
    }

    func testFetchEventsDecodingError() async {
        repository = SpaceNewsRepositoryDefault(apiClient: .decodingErrorMock)
        // when
        do {
            let articles = try await repository.fetchEvents()
            print(articles.count)
        } catch DataError.decodingError {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected DataError.decodingError but got \(error)")
        }
    }
    func testFetchNewsAndNext() async {
        // when
        let articles = try! await repository.fetchArticle()
        let articlesNext = try! await repository.fetchNextArticles()
        let articlesNext2 = try! await repository.fetchNextArticles()
        let allArticles = articles + articlesNext + articlesNext2
        // then
        XCTAssertTrue(articles.count == 3)
        XCTAssertTrue(allArticles.count == 6)
        XCTAssertTrue(articlesNext2.count == 0)
    }

}
