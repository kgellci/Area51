import CoreAPI
import Foundation

public enum SubredditRoute: APIRoute {
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
}
