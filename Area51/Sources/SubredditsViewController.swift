import SubredditService
import UIKit

class SubredditsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private let mainSubreddits = Subreddit.allSubreddits
    private var filteredMainSubreddits = [Subreddit]()
    private var filteredDefaultSubreddits = [Subreddit]()
    private var searchResultSubreddits = [Subreddit]()
    private var dataSource: SubredditDataSource! {
        didSet {
            dataSource.updated = { [weak self] in
                guard let `self` = self else {
                    return
                }

                self.filteredDefaultSubreddits = self.dataSource.subreddits
                self.tableView.reloadData()
            }
        }
    }
    private var searchDataSource: SearchDataSource! {
        didSet {
            searchDataSource.updated = { [weak self] in
                guard let `self` = self else {
                    return
                }

                self.searchResultSubreddits = self.searchDataSource.subreddits
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        dataSource = SubredditDataSource()
        searchDataSource = SearchDataSource()

        filteredMainSubreddits = mainSubreddits
        if let subreddit = mainSubreddits.first {
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

    func filterContentForSearchText(_ searchText: String) {
        if searchText == "" {
            filteredMainSubreddits = mainSubreddits
            filteredDefaultSubreddits = dataSource.subreddits
            searchResultSubreddits = []
            tableView.reloadData()
            return
        }

        filteredMainSubreddits = mainSubreddits.filter({( subreddit: Subreddit ) -> Bool in
            return subreddit.displayName.lowercased().contains(searchText.lowercased())
        })

        filteredDefaultSubreddits = dataSource.subreddits.filter({( subreddit: Subreddit) -> Bool in
            return subreddit.displayName.lowercased().contains(searchText.lowercased())
        })

        searchDataSource.refresh(withQuery: searchText)

        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func getSubreddit(forIndexPath indexPath: IndexPath) -> Subreddit? {
        switch SubredditSections(rawValue: indexPath.section) {
        case .mainSubreddits?:
            return filteredMainSubreddits[indexPath.row]
        case .defaultSubreddits?:
            return filteredDefaultSubreddits[indexPath.row]
        case .searchResultSubreddits?:
            return searchResultSubreddits[indexPath.row]
        case nil:
            return nil
        }
    }
}

extension SubredditsViewController: UITableViewDataSource, UITableViewDelegate {
    enum SubredditSections: Int {
        case mainSubreddits
        case defaultSubreddits
        case searchResultSubreddits

        public var title: String {
            switch self {
            case .mainSubreddits:
                return "Main Subreddits"
            case .defaultSubreddits:
                return "Default Subreddits"
            case .searchResultSubreddits:
                return "Search Results"
            }
        }
        public static var allSections: [SubredditSections] {
            return [.mainSubreddits, .defaultSubreddits, .searchResultSubreddits]
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
        case .mainSubreddits?:
            return filteredMainSubreddits.count
        case .defaultSubreddits?:
            return filteredDefaultSubreddits.count
        case .searchResultSubreddits?:
            return searchResultSubreddits.count
        case nil:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dataSource.loadMoreIfNeeded(currentIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubredditCell")!
        if let subreddit = getSubreddit(forIndexPath: indexPath) {
            cell.textLabel?.text = subreddit.displayName
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let subreddit = getSubreddit(forIndexPath: indexPath) {
            showSubreddit(subreddit)
        }
    }
}

extension SubredditsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
