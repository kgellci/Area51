import Foundation

public class SearchResult: Decodable {
    public let iconImgURL: URL?
    public var keyColor: String?
    public let subredditName: String?
    public let subscriberCount: Int?

    enum CodingKeys: String, CodingKey {
        case iconImgURL = "icon_img"
        case keyColor = "key_color"
        case subredditName = "name"
        case subscriberCount = "subscriber_count"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subredditName = try? values.decode(String.self, forKey: .subredditName)
        keyColor = try? values.decode(String.self, forKey: .keyColor)
        subscriberCount = try? values.decode(Int.self, forKey: .subscriberCount)

        let thumbnail: URL? = try? values.decode(URL.self, forKey: .iconImgURL)
        self.iconImgURL = thumbnail?.host != nil ? thumbnail : nil
    }
}
