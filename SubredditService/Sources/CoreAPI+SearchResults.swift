import CoreAPI
import Foundation

public extension CoreAPI {
    public static func seachPopularResults<T: Decodable>(listingRoute: APIRoute,
                                                         value: T.Type,
                                                         query: String,
                                                         completion:
        @escaping (Result<[SearchResult]>) -> Void) -> URLSessionTask {

        var parameters = [String: String]()
        parameters["query"] = query

        return self.getSearchData(forRoute: listingRoute, parameters: parameters) { result in
            let popularSearchResult = result.map(SearchResultParser.results)
            DispatchQueue.main.async {
                completion(popularSearchResult)
            }
        }
    }
}
