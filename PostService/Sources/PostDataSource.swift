import CoreAPI
import Foundation
import ListingService
import SubredditService

public class PostDataSource {
    public private(set) var posts = [Post]()
    public var updated: (() -> Void)?

    private let subreddit: Subreddit
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
        self.refreshTask = CoreAPI.results(listingRoute: PostRoute.subreddit(subreddit),
                                           value: Post.self) { [weak self] result in
                                            self?.refreshTask = nil
                                            switch result {
                                            case .success(let posts):
                                                self?.posts = posts
                                                self?.updated?()
                                            case .error:
                                                return
                                            }
        }
    }

    public func loadMoreIfNeeded(currentIndex: Int) {
        if currentIndex == self.posts.count - 1 {
            self.loadMore()
        }
    }

    private func loadMore() {
        if self.loadMoreTask != nil || self.refreshTask != nil {
            return
        }

        self.loadMoreTask = CoreAPI.results(listingRoute: PostRoute.subreddit(subreddit), value: Post.self,
                                            afterID: self.posts.last?.fullServerID) { [weak self] result in
                                                self?.loadMoreTask = nil
                                                switch result {
                                                case .success(let posts):
                                                    self?.posts.append(contentsOf: posts)
                                                    self?.updated?()
                                                case .error:
                                                    return
                                                }
        }
    }
}
