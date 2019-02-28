import CoreAPI
import XCTest

// Add a couple of functions to help checking Result types
extension XCTestCase {
    /// Assert that a result has expected data
    ///
    /// - Parameters:
    ///   - result: The Result case to check
    ///   - expectedData: The expected data
    func assert<T: Equatable>(_ result: Result<T>?,
                              containsData expectedData: T,
                              in file: StaticString = #file,
                              line: UInt = #line) {
        switch result {
        case .success(let data)?:
            XCTAssertEqual(data, expectedData, file: file, line: line)
        case .error?:
            XCTFail("Error was thrown", file: file, line: line)
        case nil:
            XCTFail("Result was nil", file: file, line: line)
        }
    }

    /// Assert that a result has an expected error
    ///
    /// - Parameters:
    ///   - result: The Result case to check
    ///   - expectedError: The expected Error
    func assert<T>(_ result: Result<T>?,
                   containsError expectedError: Error,
                   in file: StaticString = #file,
                   line: UInt = #line) {
        switch result {
        case .error(let error)?:
            XCTAssertEqual(
                error.localizedDescription,
                expectedError.localizedDescription,
                file: file, line: line
            )
        case .success?:
            XCTFail("No error thrown", file: file, line: line)
        case nil:
            XCTFail("Result was nil", file: file, line: line)
        }
    }
}
