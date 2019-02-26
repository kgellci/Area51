import Core
import XCTest

class CoreTests: XCTestCase {

    func test_strippedHtml_CanStripInlineHTMLFromString() {
        // Given
        let html = "<b>Foo</b>"

        // When
        let result = html.strippedHtml

        // Then
        XCTAssertEqual(result, "Foo")
    }

}
