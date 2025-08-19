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
        app.launchEnvironment["MyUITestsCustomView"] = "true"
        app.launch()
        
        let collectionViews = app.collectionViews
        guard collectionViews["TabViewLaunches"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }

        let cvLaunches = app.collectionViews["TabViewLaunches"]
        print(cvLaunches.debugDescription)

        collectionViews.collectionViews["TabViewLaunches"].buttons["Long March 4C | Shiyan 28 B-02-Long March 4C | Shiyan 28 B-02-Long March 4C | Shiyan 28 B-02"].swipeLeft()
        collectionViews.collectionViews["TabViewLaunches"].buttons["Long March 6A | SatNet LEO Group 09-Long March 6A | SatNet LEO Group 09-Long March 6A | SatNet LEO Group 09"].swipeLeft()
        
        let thirdButton = collectionViews.collectionViews["TabViewLaunches"].buttons["Falcon 9 Block 5 | Starlink Group 17-5-Falcon 9 Block 5 | Starlink Group 17-5-Falcon 9 Block 5 | Starlink Group 17-5"]
        thirdButton.tap()
        let thirdTitle = app.scrollViews.otherElements.staticTexts["Falcon 9 Block 5 | Starlink Group 17-5"]
        guard thirdTitle.waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        XCTAssertTrue(true, "The title should be visible")
        
        let upcomingButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Upcoming"]
        upcomingButton.tap()
        guard collectionViews["TabViewLaunches"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        XCTAssertTrue(true, "TabViewLaunches should be visible")
    }
    @MainActor
    func testUpcommingEventsSwipeAndTapAndBack() {
        let app = XCUIApplication()
        app.launchEnvironment["MyUITestsCustomView"] = "true"
        app.launch()
        
        let collectionViews = app.collectionViews
        guard collectionViews["TabViewEvents"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }

        let cvEvents = app.collectionViews["TabViewEvents"]
        print(cvEvents.debugDescription)

        collectionViews.collectionViews["TabViewEvents"].buttons["SpaceX Crew-10 Post-Flight News Conference-SpaceX Crew-10 Post-Flight News Conference"].swipeLeft()
        collectionViews.collectionViews["TabViewEvents"].buttons["CRS-33 Dragon Docking-CRS-33 Dragon Docking"].swipeLeft()
        collectionViews.collectionViews["TabViewEvents"].buttons["Juice Venus Flyby-Juice Venus Flyby"].tap()

        let thirdTitle = app.scrollViews.otherElements.staticTexts["Juice Venus Flyby"]
        guard thirdTitle.waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        XCTAssertTrue(true, "The title should be visible")
        
        let upcomingButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Upcoming"]
        upcomingButton.tap()
        guard collectionViews["TabViewEvents"].waitForExistence(timeout: 10) else {
                XCTFail()
                return
        }
        XCTAssertTrue(true, "TabViewEvents should be visible")
    }
}
