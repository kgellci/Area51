import CoreAPI
import Foundation

extension CoreAPI {
    static func listings(forSubreddit subreddit: Subreddit, afterListing: Listing? = nil,
                         completion: @escaping (Result<[Listing]>) -> Void) -> URLSessionTask {
        var parameters = [String: String]()
        if let listing = afterListing {
            parameters["after"] = listing.fullServerID
        }

        return self.getData(forRoute: subreddit, parameters: parameters) { result in
            let listingsResult = result.map(ListingParser.listings)
            DispatchQueue.main.async {
                completion(listingsResult)
            }
        }
    }
}
