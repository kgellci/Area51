import CoreAPI
import Foundation

public class SearchDataSource {
    public private(set) var searchResults = [SearchResult]()
    public var updated: (() -> Void)?

    private var refreshTask: URLSessionTask?
    private var loadMoreTask: URLSessionTask?

    public var query: String = ""

    public init() {}

    deinit {
        self.refreshTask?.cancel()
        self.refreshTask = nil
    }

    public func refreshSearchResults(withQuery query: String ) {
        self.refreshTask?.cancel()
        self.refreshTask = CoreAPI.seachPopularResults(listingRoute: SearchResultRoute.searchResultSubreddits,
                                                value: SearchResult.self,
                                                query: query) { [weak self] result in
                                                    self?.refreshTask = nil
                                                    switch result {
                                                    case .success(let searchResults):
                                                        self?.searchResults = searchResults
                                                        self?.updated?()
                                                    case .error:
                                                        return
                                                    }
        }
    }
}
