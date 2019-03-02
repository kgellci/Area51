import Core
import Foundation
import PostService
import SubredditService

class FeedViewModel {

    var subredditName: String?
    var updated: (() -> Void)?
    private let subreddit: Subreddit
    private var posts = [Post]()

    var postsCount: Int {
        return posts.count
    }

    private var dataSource: PostDataSource! {
        didSet {
            self.dataSource.updated = { [weak self] in
                if let posts = self?.dataSource.posts {
                    self?.posts = posts
                    self?.removeHtmlFromListings()
                }

                self?.updated?()
            }
        }
    }

    init(with subreddit: SubredditService.Subreddit) {
        defer {
            self.dataSource = PostDataSource(subreddit: subreddit)
        }

        self.subreddit = subreddit
        self.subredditName = subreddit.displayName
    }

    private func removeHtmlFromListings() {
        posts.forEach({$0.selfText = $0.selfText?.strippedHtml})
    }
}

extension FeedViewModel {
    func post(at index: Int) -> Post? {
        if index < posts.count {
            return posts[index]
        }
        return nil
    }

    func refreshListings() {
        dataSource.refresh()
    }

    func loadMoreIfNeeded(currentIndex: Int) {
        dataSource.loadMoreIfNeeded(currentIndex: currentIndex)
    }
}
