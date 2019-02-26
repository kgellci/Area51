import ListingService
import UIKit

class SubredditsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private let subreddits = Subreddit.allSubreddits()
    private var filteredMainSubreddits = [Subreddit]()
    private var filteredDefaultSubreddits = [Listing]()
    private var dataSource: ListingsDataSource! {
        didSet {
            dataSource.updated = { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        dataSource = ListingsDataSource(subreddit: Subreddit.defaultSubreddits )
        if let subreddit = subreddits.first {
            showSubreddit(subreddit)
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Subreddits"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func showSubreddit(_ subreddit: Subreddit) {
        let feedViewController = FeedViewController.instantiateFromStoryboard(withSubreddit: subreddit)
        splitViewController?.showDetailViewController(feedViewController.embeddedInNavigationController(),
                                                      sender: self)
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMainSubreddits = subreddits.filter({( subreddit: Subreddit ) -> Bool in
            return subreddit.name.lowercased().contains(searchText.lowercased())
        })

        filteredDefaultSubreddits = dataSource.listings.filter({( listing: Listing) -> Bool in
            return listing.displayName?.lowercased().contains(searchText.lowercased()) ?? false
        })

        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func getSubredditAtRow( forRow row: Int) -> Subreddit {
        let subredditAtRow: Subreddit
        if isFiltering() {
            subredditAtRow = filteredMainSubreddits[row]
        } else {
            subredditAtRow = subreddits[row]
        }
        return subredditAtRow
    }

    func getListingAtRow( forRow row: Int) -> Listing {
        let listingAtRow: Listing
        if isFiltering() {
            listingAtRow = filteredDefaultSubreddits[row]
        } else {
            listingAtRow = dataSource.listings[row]
        }
        return listingAtRow
    }
}

extension SubredditsViewController: UITableViewDataSource, UITableViewDelegate {
    enum SubredditSections: Int {
        case redditFeeds = 0
        case defaultFeeds = 1

        public var title: String {
            switch self {
            case .redditFeeds:
                return "Reddit Feeds"
            case .defaultFeeds:
                return "Default Feeds"
            }
        }
        public static var allSections: [SubredditSections] {
            return [.redditFeeds, .defaultFeeds]
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SubredditSections.allSections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SubredditSections(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SubredditSections(rawValue: section) {
        case .redditFeeds?:
            return isFiltering() ? filteredMainSubreddits.count : subreddits.count
        case .defaultFeeds?:
            return isFiltering() ? filteredDefaultSubreddits.count : dataSource.listings.count
        case nil:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dataSource.loadMoreIfNeeded(currentIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubredditCell")!

        switch SubredditSections(rawValue: indexPath.section) {
        case .redditFeeds?:
            let subredditAtRow = getSubredditAtRow(forRow: indexPath.row)
            cell.textLabel?.text = subredditAtRow.name
        case .defaultFeeds?:
            let listingAtRow = getListingAtRow(forRow: indexPath.row)
            cell.textLabel?.text = listingAtRow.url.absoluteString
        case nil:
            return cell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch SubredditSections(rawValue: indexPath.section) {
        case .redditFeeds?:
            let subredditAtRow = getSubredditAtRow(forRow: indexPath.row)
            showSubreddit(subredditAtRow)
        case .defaultFeeds?:
            let listingAtRow = getListingAtRow(forRow: indexPath.row)
            showSubreddit(Subreddit.other(listingAtRow.displayName!))
        case nil:
            return
        }
    }
}

extension SubredditsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
