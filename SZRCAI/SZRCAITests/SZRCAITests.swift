import XCTest
import MapKit
@testable import SZRCAI

class SZRCAITests: XCTestCase {
    
    var viewController : ViewController!
    
    override func setUp() {
        super.setUp()
        viewController = ViewController()
        if viewController != nil {
            viewController.loadView()
            viewController.viewDidLoad()
        }
    }
    
    override func setUpWithError() throws { }
    
    override func tearDownWithError() throws { }
    
    func testingVC() throws {
        XCTAssertTrue(viewController != nil)
        XCTAssertTrue(viewController.mapView != nil)
        XCTAssertTrue(viewController.mainButton != nil)
        XCTAssertTrue(viewController.clearButton != nil)
        XCTAssertTrue(viewController.buttonKVO != nil)
        XCTAssertTrue(viewController.pinsKVO != nil)
    }
    
    func testVCdelegate() {
        XCTAssertTrue(Model.shared.delegate === viewController)
    }
    
    func testUserLocation() {
        viewController.mapView.lm?.startUpdatingLocation()
        XCTAssertTrue(viewController.mapView.userLocation.coordinate != .init())
    }
    
    func testPerformanceExample() throws {
        self.measure { }
    }
}
