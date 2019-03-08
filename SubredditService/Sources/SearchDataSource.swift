import CoreAPI
import Foundation
import ListingService

public class SearchDataSource {
    public private(set) var subreddits = [Subreddit]()
    public var updated: (() -> Void)?

    private var refreshTask: URLSessionTask?
    private var loadMoreTask: URLSessionTask?

    public var query: String = ""

    public init( ) {
//        self.refresh()
    }

    deinit {
        self.refreshTask?.cancel()
        self.loadMoreTask?.cancel()
        self.refreshTask = nil
        self.loadMoreTask = nil
    }

    public func refresh(withQuery query: String ) {
        if self.refreshTask != nil {
            return
        }

        self.loadMoreTask?.cancel()
        self.loadMoreTask = nil
        self.refreshTask = CoreAPI.seachResults(listingRoute: SubredditRoute.searchResultSubreddits,
                                                value: Subreddit.self,
                                                query: query) { [weak self] result in
                                                    self?.refreshTask = nil
                                                    switch result {
                                                    case .success(let subreddits):
                                                        self?.subreddits = subreddits
                                                        self?.updated?()
                                                    case .error:
                                                        return
                                                    }
        }
    }

    public func loadMoreIfNeeded(currentIndex: Int) {
        if currentIndex == self.subreddits.count - 1 {
            self.loadMore()
        }
    }

    private func loadMore() {
        if self.loadMoreTask != nil || self.refreshTask != nil {
            return
        }

        self.loadMoreTask = CoreAPI.results(listingRoute: SubredditRoute.defaultSubreddits,
                                            value: Subreddit.self,
                                            afterID: self.subreddits.last?.fullServerID) { [weak self] result in
                                                self?.loadMoreTask = nil
                                                switch result {
                                                case .success(let subreddits):
                                                    self?.subreddits.append(contentsOf: subreddits)
                                                    self?.updated?()
                                                case .error:
                                                    return
                                                }
        }
    }
}
