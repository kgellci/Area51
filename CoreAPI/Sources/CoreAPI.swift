import Foundation

public typealias JSON = [String: Any]

public struct CoreAPI {
    private static let session = URLSession(configuration: .default)
    private static let baseURL = URL(string: "https://api.reddit.com")!

    static func getData(forRoute route: APIRoute, completion: @escaping (Result<JSON>) -> Void) {
        let url = route.resolving(baseURL: self.baseURL)
        self.session.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            if let json = self.json(from: data) {
                return completion(Result(success: json))
            }

            completion(Result(error: CoreAPIError.random))
        }.resume()
    }

    private static func json(from data: Data) -> JSON? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON
    }
}

extension CoreAPI {
    public static func popularListings(completion: @escaping (Result<[Listing]>) -> Void) {
        self.getData(forRoute: .popular) { result in
            let listingsResult = result.map(ListingParser.listrings)
            DispatchQueue.main.async {
                completion(listingsResult)
            }
        }
    }
}
