import CoreAPI
import XCTest

class ResultTests: XCTestCase {
    func test_Result_Map_WithSuccessCase_CallsTransform() {
        // Given
        let input = Result.success(0)

        // When
        let mappedResult = input.map({ String($0) })

        // Then
        switch mappedResult {
        case .success(let str):
            XCTAssertEqual(str, "0")
        case .error:
            XCTFail("Mapped result should be a string")
        }
    }

    func test_Result_Map_WithErrorCase_ReturnsError() {
        // Given
        let input: Result<String> = Result.error(CoreAPIError.random)

        // When
        let mappedResult = input.map({ String($0) })

        // Then
        switch mappedResult {
        case .error(let error as CoreAPIError):
            XCTAssertEqual(error, .random)
        default:
            XCTFail("Mapped result should be .error(CoreAPIError)")
        }
    }
}
