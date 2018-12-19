import Foundation

struct ListingParser {
    static func listrings(from json: JSON) -> [Listing] {
        guard let jsonData = json["data"] as? JSON, let children = jsonData["children"] as? [JSON] else {
            return [Listing]()
        }

        return children.compactMap(Listing.init)
    }
}
