import Foundation

public enum PostParseError: Error {
    case invalidURL
}

public class Post: Decodable {
    public let title: String
    public let url: URL
    public let thumbnailURL: URL?
    public var selfText: String?
    public let subredditName: String?
    let fullServerID: String

    enum CodingKeys: String, CodingKey {
        case innerData = "data"
    }

    enum InnerDataKeys: String, CodingKey {
        case title
        case url
        case selfText = "selftext"
        case fullServerID = "name"
        case thumbnailURL = "thumbnail"
        case subredditName = "subreddit"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let innerData = try values.nestedContainer(keyedBy: InnerDataKeys.self, forKey: .innerData)

        title = try innerData.decode(String.self, forKey: .title)
        fullServerID = try innerData.decode(String.self, forKey: .fullServerID)
        subredditName = try? innerData.decode(String.self, forKey: .subredditName)
        selfText = try? innerData.decode(String.self, forKey: .selfText)

        let urlString = try innerData.decode(String.self, forKey: .url)
        // Seems Reddit can return a url with invalid characters which blows up parsing
        guard let decodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: decodedURLString) else {
                throw PostParseError.invalidURL
        }

        self.url = url
        let thumbnail: URL? = try? innerData.decode(URL.self, forKey: .thumbnailURL)
        self.thumbnailURL = thumbnail?.host != nil ? thumbnail : nil
    }
}
