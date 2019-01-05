import Foundation

public class Listing: Decodable {
    public let title: String
    public let url: URL
    public let thumbnailURL: URL?
    let fullServerID: String

    enum CodingKeys: String, CodingKey {
        case innerData = "data"
    }

    enum InnerDataKeys: String, CodingKey {
        case title
        case url
        case fullServerID = "name"
        case thumbnailURL = "thumbnail"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let innerData = try values.nestedContainer(keyedBy: InnerDataKeys.self, forKey: .innerData)
        self.title = try innerData.decode(String.self, forKey: .title)
        self.url = try innerData.decode(URL.self, forKey: .url)
        self.fullServerID = try innerData.decode(String.self, forKey: .fullServerID)

        let thumbnail: URL? = try? innerData.decode(URL.self, forKey: .thumbnailURL)
        self.thumbnailURL = thumbnail?.host != nil ? thumbnail : nil
    }
}
