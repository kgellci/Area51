import CoreAPI
import XCTest

class CoreAPITests: XCTestCase {
    /// Use a stubbed route
    var route: APIRoute!

    override func setUp() {
        super.setUp()
        route = RouterMock()
    }

    func test_CoreAPI_GetData_ReturnsDataResult() {
        // Given
        let data = "foo".data(using: .utf8)!
        let sessionMock = SessionMock(data: data, response: nil, error: nil)

        // When
        var result: Result<Data>?
        _ = CoreAPI.getData(forRoute: route, parameters: [:], session: sessionMock) {
            result = $0
        }

        // Then
        assert(result, containsData: data)
    }

    func test_CoreAPI_GetData_WithNoData_ReturnsError() {
        // Given
        let sessionMock = SessionMock(data: nil, response: nil, error: nil)

        // When
        var theResult: Result<Data>?
        _ = CoreAPI.getData(forRoute: route, parameters: [:], session: sessionMock) {
            theResult = $0
        }

        // Then
        assert(theResult, containsError: CoreAPIError.random)
    }

    func test_CoreAPI_GetData_ResumesTask() {
        // Given
        let sessionMock = SessionMock(data: nil, response: nil, error: nil)

        // When
        let task = CoreAPI.getData(forRoute: route,
                                   parameters: [:],
                                   session: sessionMock,
                                   completion: { _ in }) as! DataTaskMock

        // Then
        XCTAssertTrue(task.resumeWasCalled)
    }
}
