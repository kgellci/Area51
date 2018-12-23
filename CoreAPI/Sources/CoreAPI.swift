import Foundation

public typealias JSON = [String: Any]

public struct CoreAPI {
    private static let session = URLSession(configuration: .default)
    private static let baseURL = URL(string: "https://api.reddit.com")!

    static func getData(forRoute route: APIRoute, parameters: [String: String],
                        completion: @escaping (Result<JSON>) -> Void) -> URLSessionTask {
        let url = route.resolving(baseURL: self.baseURL, parameters: parameters)
        let task = self.session.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            if let json = self.json(from: data) {
                return completion(Result(success: json))
            }

            completion(Result(error: CoreAPIError.random))
        }

        task.resume()
        return task
    }

    private static func json(from data: Data) -> JSON? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON
    }
}

extension CoreAPI {
    public static func popularListings(afterListing: Listing? = nil,
                                       completion: @escaping (Result<[Listing]>) -> Void) -> URLSessionTask {
        var parameters = [String: String]()
        if let listing = afterListing {
            parameters["after"] = listing.fullServerID
        }

        return self.getData(forRoute: .popular, parameters: parameters) { result in
            let listingsResult = result.map(ListingParser.listrings)
            DispatchQueue.main.async {
                completion(listingsResult)
            }
        }
    }
}
