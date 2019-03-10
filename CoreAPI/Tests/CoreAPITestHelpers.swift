import CoreAPI
import Foundation

/// A partial mock that reports if `.resume()` was called
class DataTaskMock: URLSessionDataTask {
    var resumeWasCalled = false
    override func resume() {
        resumeWasCalled = true
    }
}

/// A network session that allows returning stubbed data
struct SessionMock: NetworkSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, response, error)
        return DataTaskMock()
    }
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionDataTask {
        completionHandler(data, response, error)
        return DataTaskMock()
    }
}

/// A test route
class RouterMock: APIRoute {
    var path: String {
        return "/test"
    }
}
