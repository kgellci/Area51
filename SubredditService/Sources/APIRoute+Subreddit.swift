import CoreAPI
import Foundation

public enum SubredditRoute: APIRoute {
    case defaultSubreddits
    case searchResultSubreddits

    public var path: String {
        switch self {
        case .defaultSubreddits:
            return "/subreddits/default"
        case .searchResultSubreddits:
            return "/subreddits/search"
        }
    }

    public var name: String {
        switch self {
        case .defaultSubreddits:
            return "/Defaults"
        case .searchResultSubreddits:
            return "/Search"
        }
    }
}
