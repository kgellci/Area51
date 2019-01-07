import CoreAPI
import Foundation

public class ListingsDataSource {

    public typealias UpdatedHandler = ([Listing]?) -> Void

    private let subreddit: Subreddit
    public private(set) var listings = [Listing]()

    private var refreshTask: URLSessionTask?
    private var loadMoreTask: URLSessionTask?

    public init(subreddit: Subreddit) {
        self.subreddit = subreddit
    }

    deinit {
        self.refreshTask?.cancel()
        self.loadMoreTask?.cancel()
        self.refreshTask = nil
        self.loadMoreTask = nil
    }

    public func refresh(updatedHandler handler: @escaping UpdatedHandler) {
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
                handler(self?.listings)
            case .error:
                return
            }
        }
    }

    public func loadMoreIfNeeded(currentIndex: Int, updatedHandler handler: @escaping UpdatedHandler) {
        if currentIndex == self.listings.count - 1 {
            loadMore(updatedHandler: handler)
        }
    }

    private func loadMore(updatedHandler handler: @escaping UpdatedHandler) {
        if self.loadMoreTask != nil || self.refreshTask != nil {
            return
        }

        self.loadMoreTask = CoreAPI.listings(forSubreddit: self.subreddit,
                                             afterListing: self.listings.last) { [weak self] result in
            self?.loadMoreTask = nil
            switch result {
            case .success(let listings):
                self?.listings.append(contentsOf: listings)
                handler(self?.listings)
            case .error:
                return
            }
        }
    }
}
