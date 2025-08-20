//
//  TheSpaceNewsUITests.swift
//  TheSpaceNewsUITests
//
//  Created by Pablo J. Bertola on 15/08/2025.
//

import XCTest

final class TheSpaceNewsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testUpcommingLaunchesSwipeAndTapAndBack() {
        let app = XCUIApplication()

        app.launchEnvironment["customUITestedUpcoming"] = "mock"
        app.launchEnvironment["customUITestedNews"] = "mock"
        app.launch()
        
        let collectionViews = app.collectionViews
        guard collectionViews["TabViewLaunches"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }

        let cvLaunches = app.collectionViews["TabViewLaunches"]
        print(cvLaunches.debugDescription)

        app.images["Long March 4C | Shiyan 28 B-02"].swipeLeft()
        app.images["Long March 6A | SatNet LEO Group 09"].swipeLeft()
        
        let thirdButton = app.images["Falcon 9 Block 5 | Starlink Group 17-5"]
        thirdButton.tap()
        let thirdTitle = app.scrollViews.otherElements.staticTexts["Falcon 9 Block 5 | Starlink Group 17-5"]
        guard thirdTitle.waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        app.navigationBars.buttons["Upcoming"].tap()
        guard collectionViews["TabViewLaunches"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
    }
    @MainActor
    func testUpcommingEventsSwipeAndTapAndBack() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "mock"
        app.launchEnvironment["customUITestedNews"] = "mock"
        app.launch()
        
        let collectionViews = app.collectionViews
        guard collectionViews["TabViewEvents"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }

        let cvEvents = app.collectionViews["TabViewEvents"]
        print(cvEvents.debugDescription)
        app.images["Long March 4C | Shiyan 28 B-02"].swipeLeft()
        
        app.images["SpaceX Crew-10 Post-Flight News Conference"].swipeLeft()
        app.images["CRS-33 Dragon Docking"].swipeLeft()
        app.images["Juice Venus Flyby"].tap()

        let thirdTitle = app.scrollViews.otherElements.staticTexts["Juice Venus Flyby"]
        guard thirdTitle.waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        
        app.navigationBars.buttons["Upcoming"].tap()
        guard collectionViews["TabViewEvents"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
    }
    @MainActor
    func testNewsListGoToWebAndReturnUI() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "mock"
        app.launchEnvironment["customUITestedNews"] = "mock"
        app.activate()
        
        guard app.buttons["List"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        app.buttons["List"].tap()
        guard app.collectionViews["ListNews"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        let firtsRow = app.images.matching(identifier: "NewsRowView").element(boundBy: 0)
        guard firtsRow.waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        firtsRow.tap()

        guard app.webViews["ArticleWebView"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        app.buttons["News Articles"].tap()
        guard app.collectionViews["ListNews"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
    }
    @MainActor
    func testUpcomingInvalidURL() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "invalidUrlMock"
        app.launchEnvironment["customUITestedNews"] = "mock"
        app.activate()
        guard app.staticTexts["Invalid URL"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
    }
    @MainActor
    func testUpcomingDecodingError() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "decodingErrorMock"
        app.launchEnvironment["customUITestedNews"] = "mock"
        app.activate()
        guard app.staticTexts["Decoding Error"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }

    }
    @MainActor
    func testUpcomingNetworkError() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "networkErrorDetail"
        app.launchEnvironment["customUITestedNews"] = "mock"
        app.activate()
        guard app.staticTexts["Request was throttled. Expected available in 2441 seconds."].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
    }
    @MainActor
    func testNewsInvalidURL() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "mock"
        app.launchEnvironment["customUITestedNews"] = "invalidUrlMock"
        app.activate()
        guard app.buttons["List"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        app.buttons["List"].tap()
        guard app.staticTexts["Invalid URL"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
    }
    @MainActor
    func testNewsDecodingError() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "mock"
        app.launchEnvironment["customUITestedNews"] = "decodingErrorMock"
        app.activate()
        guard app.buttons["List"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        app.buttons["List"].tap()
        guard app.staticTexts["Decoding Error"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }

    }
    @MainActor
    func testNewsNetworkError() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "mock"
        app.launchEnvironment["customUITestedNews"] = "networkErrorDetail"
        app.activate()
        guard app.buttons["List"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        app.buttons["List"].tap()
        guard app.staticTexts["Request was throttled. Expected available in 2441 seconds."].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
    }
    @MainActor
    func testNewsEmpty() {
        let app = XCUIApplication()
        app.launchEnvironment["customUITestedUpcoming"] = "mock"
        app.launchEnvironment["customUITestedNews"] = "mockEmpty"
        app.activate()
        guard app.buttons["List"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        app.buttons["List"].tap()
        guard app.staticTexts["No results for \"\""].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
    }

}
