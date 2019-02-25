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
            self.dataSource.updated = { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupSearchController()
        self.dataSource = ListingsDataSource(subreddit: Subreddit.defaultSubreddits )
        if let subreddit = self.subreddits.first {
            self.showSubreddit(subreddit)
        }
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        self.splitViewController?.showDetailViewController(feedViewController.embeddedInNavigationController(),
                                                           sender: self)
    }

    func searchBarIsEmpty() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
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
            subredditAtRow = self.filteredMainSubreddits[row]
        } else {
            subredditAtRow = self.subreddits[row]
        }
        return subredditAtRow
    }

    func getListingAtRow( forRow row: Int) -> Listing {
        let listingAtRow: Listing
        if isFiltering() {
            listingAtRow = self.filteredDefaultSubreddits[row]
        } else {
            listingAtRow = self.dataSource.listings[row]
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
        switch section {
        case 0:
            return isFiltering() ? self.filteredMainSubreddits.count : self.subreddits.count
        default:
            return isFiltering() ? self.filteredDefaultSubreddits.count : self.dataSource.listings.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.dataSource.loadMoreIfNeeded(currentIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubredditCell")!
        let textLabelString: String
        if indexPath.section == 0 {
            let subredditAtRow = getSubredditAtRow(forRow: indexPath.row)
            textLabelString = subredditAtRow.name
        } else {
            let listing = getListingAtRow(forRow: indexPath.row)
            textLabelString = listing.url.absoluteString
        }
        cell.textLabel?.text = textLabelString
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedSubreddit: Subreddit
        if indexPath.section == 0 {
            let subredditAtRow = getSubredditAtRow(forRow: indexPath.row)
            selectedSubreddit = subredditAtRow
        } else {
            let listing = getListingAtRow(forRow: indexPath.row)
            selectedSubreddit = Subreddit.other(listing.displayName!)
        }
        self.showSubreddit(selectedSubreddit)
    }
}

extension SubredditsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
