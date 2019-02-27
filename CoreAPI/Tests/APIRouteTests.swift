/// Mark CoreAPI as testable so we can access internal functions
@testable import CoreAPI
import XCTest

class APIRouteTests: XCTestCase {

    func test_APIRoute_ProducesURL() {
        // Given
        let baseURL = URL(string: "https://reddit.com")!
        let router = RouterMock()

        // When
        let url = router.resolving(baseURL: baseURL, parameters: nil)

        // Then
        XCTAssertEqual(url.absoluteString, "https://reddit.com/test")
    }

    func test_APIRoute_ProducesURL_WithParameters() {
        // Given
        let baseURL = URL(string: "https://reddit.com")!
        let parameters = ["foo": "bar"]
        let router = RouterMock()

        // When
        let url = router.resolving(baseURL: baseURL, parameters: parameters)

        // Then
        XCTAssertEqual(url.absoluteString, "https://reddit.com/test?foo=bar")
    }

}
