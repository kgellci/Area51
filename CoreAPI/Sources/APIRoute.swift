import Foundation

public enum APIRoute: String {
    case popular = "/r/popular"

    func resolving(baseURL: URL, parameters: [String: String]?) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.path = self.rawValue
        components.queryItems = parameters?.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
