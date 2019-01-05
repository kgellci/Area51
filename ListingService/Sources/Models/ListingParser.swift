import Foundation

struct ListingParser {
    static func listings(from data: Data) -> [Listing] {
        let jsonDecoder = JSONDecoder()
        return (try? jsonDecoder.decode(ListingResponse.self, from: data).listings) ?? [Listing]()
    }
}
