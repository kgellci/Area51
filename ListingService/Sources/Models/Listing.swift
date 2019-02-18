import Foundation

public enum ListingParseError: Error {
    case invalidURL
}

public class Listing: Decodable {
    public let title: String
    public let url: URL
    public let thumbnailURL: URL?
    public var displayName: String?
    let fullServerID: String

    enum CodingKeys: String, CodingKey {
        case innerData = "data"
    }

    enum InnerDataKeys: String, CodingKey {
        case title
        case url
        case fullServerID = "name"
        case thumbnailURL = "thumbnail"
        case displayName = "display_name"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let innerData = try values.nestedContainer(keyedBy: InnerDataKeys.self, forKey: .innerData)
        self.title = try innerData.decode(String.self, forKey: .title)
        self.fullServerID = try innerData.decode(String.self, forKey: .fullServerID)
        // Deal with error thrown when loading subreddit content the key display_name is not present and continue
        do {
           self.displayName = try innerData.decode(String.self, forKey: .displayName)
        } catch {
        }

        let urlString = try innerData.decode(String.self, forKey: .url)
        // Seems Reddit can return a url with invalid characters which blows up parsing
        guard let decodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: decodedURLString) else {
            throw ListingParseError.invalidURL
        }

        self.url = url
        let thumbnail: URL? = try? innerData.decode(URL.self, forKey: .thumbnailURL)
        self.thumbnailURL = thumbnail?.host != nil ? thumbnail : nil
    }
}
