import Foundation

public enum SubredditParseError: Error {
    case notSubredditType
}

public class Subreddit: Decodable {
    private static let kind = "t5"

    public let displayName: String
    public var iconImgURL: URL?
    let fullServerID: String?

    enum CodingKeys: String, CodingKey {
        case data
        case kind
    }

    enum InnerDataKeys: String, CodingKey {
        case fullServerID = "name"
        case displayName = "display_name"
        case iconImg = "icon_img"
    }

    public init (displayName: String) {
        self.displayName = displayName
        fullServerID = nil
    }

    public convenience init(displayName: String, iconImgURL: URL?) {
        self.init(displayName: displayName)
        self.iconImgURL = iconImgURL
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        guard try values.decode(String.self, forKey: .kind) == Subreddit.kind else {
            throw SubredditParseError.notSubredditType
        }

        let innerData = try values.nestedContainer(keyedBy: InnerDataKeys.self, forKey: .data)

        fullServerID = try innerData.decode(String.self, forKey: .fullServerID)
        displayName = try innerData.decode(String.self, forKey: .displayName)
        let thumbnail: URL? = try? innerData.decode(URL.self, forKey: .iconImg)
        self.iconImgURL = thumbnail?.host != nil ? thumbnail : nil
    }
}

public extension Subreddit {
    public static var allSubreddits: [Subreddit] {
        return [Subreddit(displayName: "Popular"), Subreddit(displayName: "News")]
    }

    public var path: String {
        return "/r/\(displayName)"
    }
}
