import Foundation

/// Defines a NetworkSession protocol to allow easier testing
public protocol NetworkSession {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

/// Conform `URLSession` to `NetworkSession`
extension URLSession: NetworkSession { }
