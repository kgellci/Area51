import CoreAPI
import Foundation

public extension CoreAPI {
    public static func results<T: Decodable>(listingRoute: APIRoute, value: T.Type, afterID: String? = nil,
                                             completion: @escaping (Result<[T]>) -> Void) -> URLSessionTask {
        var parameters = [String: String]()
        if let afterID = afterID {
            parameters["after"] = afterID
        }

        return self.getData(forRoute: listingRoute, parameters: parameters) { result in
            let listingsResult = result.map(ListingParser<T>.results)
            DispatchQueue.main.async {
                completion(listingsResult)
            }
        }
    }
    public static func seachResults<T: Decodable>(listingRoute: APIRoute,
                                                  value: T.Type,
                                                  afterID: String? = nil,
                                                  query: String,
                                                  completion: @escaping (Result<[T]>) -> Void) -> URLSessionTask {

        var parameters = [String: String]()
        parameters["q"] = query
        if let afterID = afterID {
            parameters["after"] = afterID
        }

        return self.getSearchData(forRoute: listingRoute, parameters: parameters, query: query) { result in
            let listingsResult = result.map(ListingParser<T>.results)
            DispatchQueue.main.async {
                completion(listingsResult)
            }
        }
    }
}
