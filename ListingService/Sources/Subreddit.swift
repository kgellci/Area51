import CoreAPI
import Foundation

public enum Subreddit: APIRoute {
    case popular
    case news
    case other(String)

    public var path: String {
        switch self {
        case .popular:
            return "/r/popular"
        case .news:
            return "/r/news"
        case .other(let name):
            return "/r/" + name
        }
    }

    public var name: String {
        switch self {
        case .popular:
            return "Popular"
        case .news:
            return "News"
        case .other(let name):
            return name
        }
    }

    public static func allSubreddits() -> [Subreddit] {
        return [.popular, .news]
    }
}
