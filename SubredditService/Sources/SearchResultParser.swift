import Foundation

struct SearchResultParser {
    static func results(from data: Data) -> [SearchResult] {
        let jsonDecoder = JSONDecoder()
        return (try? jsonDecoder.decode(SearchResponse.self, from: data).searchResults) ?? [SearchResult]()
    }
}
