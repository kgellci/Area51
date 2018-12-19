import CoreAPI
import Foundation

enum ListingFeed {
    case popular
}

class ListingsDataSource {
    private let listingFeed: ListingFeed
    private(set) var listings = [Listing]()
    var updated: (() -> Void)?

    init(listingFeed: ListingFeed) {
        self.listingFeed = listingFeed
        self.refresh()
    }

    func refresh() {
        CoreAPI.popularListings { [weak self] result in
            switch result {
            case .success(let listings):
                self?.listings = listings
                self?.updated?()
            case .error:
                return
            }
        }
    }
}
