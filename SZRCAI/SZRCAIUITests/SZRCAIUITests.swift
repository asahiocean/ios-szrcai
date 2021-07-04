import XCTest

class SZRCAIUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
    }
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let arcticOceanMap = app.maps.containing(.other, identifier:"Arctic Ocean").element
        arcticOceanMap.tap()
        arcticOceanMap.tap()
        app.maps.containing(.other, identifier:"Russia").element.swipeRight()
        
        let russiaMap = app.maps.containing(.other, identifier:"Russia").element
        russiaMap.swipeRight()
        russiaMap.swipeRight()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                // XCUIApplication().launch()
            }
        }
    }
}
