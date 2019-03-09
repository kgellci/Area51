import CoreAPI
import Foundation

public enum SubredditRoute: APIRoute {
    case defaultSubreddits

    public var path: String {
        switch self {
        case .defaultSubreddits:
            return "/subreddits/default"
        }
    }

    public var name: String {
        switch self {
        case .defaultSubreddits:
            return "/Defaults"
        }
    }
}
