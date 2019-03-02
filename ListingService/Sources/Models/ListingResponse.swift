import Foundation

struct ListingResponse<T: Decodable>: Decodable {
    let results: [T]

    enum CodingKeys: String, CodingKey {
        case data
    }

    enum DataKeys: String, CodingKey {
        case resutls = "children"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        results = try data.decode([T].self, forKey: .resutls)
    }
}
