import CoreAPI
import Foundation

enum ListingFeed {
    case popular
}

class ListingsDataSource {
    private let listingFeed: ListingFeed
    private(set) var listings = [Listing]()
    var updated: (() -> Void)?

    private var refreshTask: URLSessionTask?
    private var loadMoreTask: URLSessionTask?

    init(listingFeed: ListingFeed) {
        self.listingFeed = listingFeed
        self.refresh()
    }

    func refresh() {
        if self.refreshTask != nil {
            return
        }

        self.loadMoreTask?.cancel()
        self.loadMoreTask = nil
        self.refreshTask = CoreAPI.popularListings { [weak self] result in
            self?.refreshTask = nil
            switch result {
            case .success(let listings):
                self?.listings = listings
                self?.updated?()
            case .error:
                return
            }
        }
    }

    func loadMoreIFNeeded(currendIndexPath: IndexPath) {
        if currendIndexPath.row == self.listings.count - 1 {
            self.loadMore()
        }
    }

    private func loadMore() {
        if self.loadMoreTask != nil || self.refreshTask != nil {
            return
        }

        self.loadMoreTask = CoreAPI.popularListings(afterListing: self.listings.last) { [weak self] result in
            self?.loadMoreTask = nil
            switch result {
            case .success(let listings):
                self?.listings.append(contentsOf: listings)
                self?.updated?()
            case .error:
                return
            }

        }
    }
}
