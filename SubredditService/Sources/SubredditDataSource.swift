import CoreAPI
import Foundation
import ListingService

public class SubredditDataSource {
    public private(set) var subreddits = [Subreddit]()
    private var pagingFinished: Bool
    public var updated: (() -> Void)?

    private var refreshTask: URLSessionTask?
    private var loadMoreTask: URLSessionTask?

    public init() {
        self.pagingFinished = false
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
        self.refreshTask = CoreAPI.results(listingRoute: SubredditRoute.defaultSubreddits,
                                           value: Subreddit.self) { [weak self] result in
            self?.refreshTask = nil
            switch result {
            case .success(let subreddits):
                self?.subreddits = subreddits
                self?.pagingFinished = self?.setPagingState(count: subreddits.count) ?? false
                self?.updated?()
            case .error:
                return
            }
        }
    }

    public func loadMoreIfNeeded(currentIndex: Int) {
        if currentIndex == self.subreddits.count - 1 && !self.pagingFinished {
            self.loadMore()
        }
    }

    private func loadMore() {
        if self.loadMoreTask != nil || self.refreshTask != nil {
            return
        }

        self.loadMoreTask = CoreAPI.results(listingRoute: SubredditRoute.defaultSubreddits, value: Subreddit.self,
                                            afterID: self.subreddits.last?.fullServerID) { [weak self] result in
            self?.loadMoreTask = nil
            switch result {
            case .success(let subreddits):
                self?.subreddits.append(contentsOf: subreddits)
                self?.pagingFinished = self?.setPagingState(count: subreddits.count) ?? false
                self?.updated?()
            case .error:
                return
            }
        }
    }
}

extension SubredditDataSource {
    func setPagingState(count: Int) -> Bool {
        if count == 0 {
            return true
        }
        return false
    }
}
