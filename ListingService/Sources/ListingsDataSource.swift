import CoreAPI
import Foundation

public enum ListingFeed {
    case popular
    case news
}

public class ListingsDataSource {
    private let listingFeed: ListingFeed
    public private(set) var listings = [Listing]()
    public var updated: (() -> Void)?

    private var refreshTask: URLSessionTask?
    private var loadMoreTask: URLSessionTask?

    public init(listingFeed: ListingFeed) {
        self.listingFeed = listingFeed
        self.refresh()
    }

    public func refresh() {
        if self.refreshTask != nil {
            return
        }

        self.loadMoreTask?.cancel()
        self.loadMoreTask = nil
        switch listingFeed {
        case .popular:
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
        case .news:
            self.refreshTask = CoreAPI.newsListings { [weak self] result in
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
    }

    public func loadMoreIfNeeded(currentIndex: Int) {
        if currentIndex == self.listings.count - 1 {
            self.loadMore()
        }
    }

    private func loadMore() {
        if self.loadMoreTask != nil || self.refreshTask != nil {
            return
        }
        switch listingFeed {
        case .popular:
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
        case .news:
        self.loadMoreTask = CoreAPI.newsListings(afterListing: self.listings.last) { [weak self] result in
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
}
