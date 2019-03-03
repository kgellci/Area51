import CoreAPI
import Foundation
import SubredditService

public enum PostRoute: APIRoute {
    case subreddit(Subreddit)

    public var path: String {
        switch self {
        case .subreddit(let subreddit):
            return subreddit.path
        }
    }

    public var name: String {
        switch self {
        case .subreddit(let subreddit):
            return subreddit.displayName
        }
    }
}
