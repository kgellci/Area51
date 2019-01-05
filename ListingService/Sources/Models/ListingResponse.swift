import Foundation

struct ListingResponse: Decodable {
    let listings: [Listing]

    enum CodingKeys: String, CodingKey {
        case data
    }

    enum DataKeys: String, CodingKey {
        case listings = "children"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        listings = try data.decode([Listing].self, forKey: .listings)
    }
}
