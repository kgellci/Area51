import Foundation

public enum SubredditSearchParseError: Error {
    case invalidURL
}

public class SearchResponse: Decodable {
    public let searchResults: [SearchResult]

    enum CodingKeys: String, CodingKey {
        case innerData = "subreddits"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        searchResults = try values.decode([SearchResult].self, forKey: .innerData)

    }
}
