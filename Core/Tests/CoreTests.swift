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

    func test_strippedHtml_StripsTrailingWhitespace() {
        // Given
        let html = "<h1>Foo</h1>"

        // When
        let result = html.strippedHtml

        // Then
        XCTAssertEqual(result, "Foo")
    }

    func test_strippedHtml_DoesNotStripInnerNewlines() {
        // Given
        let html = "<h1>Foo<br>Bar</h1>"

        // When
        let result = html.strippedHtml

        // Then
        XCTAssertEqual(result, "Foo\u{2028}Bar")
    }

}
