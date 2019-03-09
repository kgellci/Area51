import CoreAPI
import Foundation

public enum SearchResultRoute: APIRoute {
    case searchResultSubreddits

    public var path: String {
        switch self {
        case .searchResultSubreddits:
            return "/api/search_subreddits.json"
        }
    }

    public var name: String {
        switch self {
        case .searchResultSubreddits:
            return "/Search"
        }
    }
}
