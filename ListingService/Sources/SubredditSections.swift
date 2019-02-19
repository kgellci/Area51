import Foundation

public enum SubredditSections: Int {
    case redditFeeds = 0
    case defaultFeeds = 1
    
    public var title: String {
        switch self {
        case .redditFeeds:
            return "Reddit Feeds"
        case .defaultFeeds:
            return "Default Feeds"
        }
    }
    public static var allSections: [SubredditSections] {
        return [.redditFeeds , .defaultFeeds]
    }
}
