import Foundation

public enum APIRoute: String {
    case popular = "/r/popular"

    func resolving(baseURL: URL) -> URL {
        return baseURL.appendingPathComponent(self.rawValue)
    }
}
