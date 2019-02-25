import Core
import Foundation
import ListingService

class FeedViewModel {

    var subredditName: String?
    var updated: (() -> Void)?
    private let subreddit: Subreddit
    private var listings = [Listing]()

    var listingsCount: Int {
        return listings.count
    }

    private var dataSource: ListingsDataSource! {
        didSet {
            self.dataSource.updated = { [weak self] in
                if let listings = self?.dataSource.listings {
                    self?.listings = listings
                    self?.removeHtmlFromListings()
                }

                self?.updated?()
            }
        }
    }

    init(with subreddit: Subreddit) {
        defer {
            self.dataSource = ListingsDataSource(subreddit: self.subreddit)
        }

        self.subreddit = subreddit
        self.subredditName = subreddit.name
    }

    private func removeHtmlFromListings() {
        listings.forEach({$0.displayName = $0.displayName?.strippedHtml})
        listings.forEach({$0.selfText = $0.selfText?.strippedHtml})
    }
}

extension FeedViewModel {
    func listing(at index: Int) -> Listing? {
        if index < listings.count {
            return listings[index]
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
