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
        let expectation = XCTestExpectation(description: "Returns data")
        let data = "foo".data(using: .utf8)!
        let sessionMock = SessionMock(data: data, response: nil, error: nil)

        _ = CoreAPI.getData(forRoute: route, parameters: [:], session: sessionMock) { result in
            defer { expectation.fulfill() }

            // Check result
            switch result {
            case .success(let returnedData):
                XCTAssertEqual(returnedData, data)
            case .error:
                XCTFail("Result case should be .success")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_CoreAPI_GetData_WithNoData_ReturnsError() {
        let expectation = XCTestExpectation(description: "Returns error")
        let sessionMock = SessionMock(data: nil, response: nil, error: nil)

        _ = CoreAPI.getData(forRoute: route, parameters: [:], session: sessionMock) { result in
            defer { expectation.fulfill() }

            // Check result
            switch result {
            case .success:
                XCTFail("Result should not be successful")
            case .error(let error as CoreAPIError):
                XCTAssertEqual(error, CoreAPIError.random)
            case .error:
                XCTFail("Result should be a CoreAPIError")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_CoreAPI_GetData_ResumesTask() {
        let sessionMock = SessionMock(data: nil, response: nil, error: nil)

        let task = CoreAPI.getData(forRoute: route,
                                   parameters: [:],
                                   session: sessionMock,
                                   completion: { _ in }) as! DataTaskMock

        XCTAssertTrue(task.resumeWasCalled)
    }
}
