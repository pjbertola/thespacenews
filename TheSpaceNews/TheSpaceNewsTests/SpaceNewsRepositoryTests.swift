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

    func testFetchArticlesAndNext() async {
        // when
        let articles = try! await repository.fetchArticles()
        let nextArticles = try! await repository.fetchNextArticles()
        let nextArticles2 = try! await repository.fetchNextArticles()
        let allArticles = articles + nextArticles + nextArticles2
        // then
        XCTAssertTrue(allArticles.count == 6)
        XCTAssertTrue(nextArticles2.count == 0)
    }

    func testFetchArticlesInvalidURL() async {
        repository = SpaceNewsRepositoryDefault(apiClient: .invalidUrlMock)
        // when
        do {
            let articles = try await repository.fetchArticles()
            print(articles.count)
        } catch DataError.invalidURL {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected DataError.invalidURL but got \(error)")
        }
    }

    func testFetchArticlesDecodingError() async {
        repository = SpaceNewsRepositoryDefault(apiClient: .decodingErrorMock)
        // when
        do {
            let articles = try await repository.fetchArticles()
            print(articles.count)
        } catch DataError.decodingError {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected DataError.invalidURL but got \(error)")
        }
    }
}
