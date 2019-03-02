import CoreAPI
import Foundation

public enum SubredditRoute: APIRoute {
    case defaultSubreddits

    public var path: String {
        return "/subreddits/default"
    }

    public var name: String {
        return "Defaults"
    }
}
