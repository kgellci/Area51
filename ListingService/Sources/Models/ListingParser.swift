import Foundation

struct ListingParser<T: Decodable> {
    static func results(from data: Data) -> [T] {
        let jsonDecoder = JSONDecoder()
        return (try? jsonDecoder.decode(ListingResponse.self, from: data).results) ?? [T]()
    }
}
