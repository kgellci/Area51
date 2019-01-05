import Foundation

public class Listing: Decodable {
    public let title: String
    public let url: URL
    let fullServerID: String

    enum CodingKeys: String, CodingKey {
        case innerData = "data"
    }

    enum InnerDataKeys: String, CodingKey {
        case title
        case url
        case fullServerID = "name"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let innerData = try values.nestedContainer(keyedBy: InnerDataKeys.self, forKey: .innerData)
        title = try innerData.decode(String.self, forKey: .title)
        url = try innerData.decode(URL.self, forKey: .url)
        fullServerID = try innerData.decode(String.self, forKey: .fullServerID)
    }
}
