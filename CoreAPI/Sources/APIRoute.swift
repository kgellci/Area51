import Foundation

public protocol APIRoute {
    var path: String { get }
}

extension APIRoute {
    func resolving(baseURL: URL, parameters: [String: String]?) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.path = self.path
        components.queryItems = parameters?.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
