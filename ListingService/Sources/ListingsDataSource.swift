import CoreAPI
import Foundation

public class ListingsDataSource {
    private let subreddit: Subreddit
    public private(set) var listings = [Listing]()
    public var updated: (() -> Void)?

    private var refreshTask: URLSessionTask?
    private var loadMoreTask: URLSessionTask?

    public init(subreddit: Subreddit) {
        self.subreddit = subreddit
        self.refresh()
    }

    deinit {
        self.refreshTask?.cancel()
        self.loadMoreTask?.cancel()
        self.refreshTask = nil
        self.loadMoreTask = nil
    }

    public func refresh() {
        if self.refreshTask != nil {
            return
        }

        self.loadMoreTask?.cancel()
        self.loadMoreTask = nil
        self.refreshTask = CoreAPI.listings(forSubreddit: self.subreddit) { [weak self] result in
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

    public func loadMoreIfNeeded(currentIndex: Int) {
        if currentIndex == self.listings.count - 1 {
            self.loadMore()
        }
    }

    private func loadMore() {
        if self.loadMoreTask != nil || self.refreshTask != nil {
            return
        }

        self.loadMoreTask = CoreAPI.listings(forSubreddit: self.subreddit,
                                             afterListing: self.listings.last) { [weak self] result in
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
