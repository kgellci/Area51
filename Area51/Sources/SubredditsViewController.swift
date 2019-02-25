import ListingService
import UIKit

class SubredditsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let subreddits = Subreddit.allSubreddits()
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
        self.dataSource = ListingsDataSource(subreddit: Subreddit.defaultSubreddits )
        if let subreddit = self.subreddits.first {
            self.showSubreddit(subreddit)
        }
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    private func showSubreddit(_ subreddit: Subreddit) {
        let feedViewController = FeedViewController.instantiateFromStoryboard(withSubreddit: subreddit)
        self.splitViewController?.showDetailViewController(feedViewController.embeddedInNavigationController(),
                                                           sender: self)
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
        if let tableViewSection = SubredditSections(rawValue: section) {
            switch tableViewSection {
            case .redditFeeds:
                return self.subreddits.count
            case .defaultFeeds:
                return self.dataSource.listings.count
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.dataSource.loadMoreIfNeeded(currentIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubredditCell")!
        if let tableViewSection = SubredditSections(rawValue: indexPath.section) {
            switch tableViewSection {
            case .redditFeeds:
                cell.textLabel?.text = self.subreddits[indexPath.row].name
            case .defaultFeeds:
                let listing = self.dataSource.listings[indexPath.row]
                cell.textLabel?.text = listing.url.absoluteString
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let tableViewSection = SubredditSections(rawValue: indexPath.section) {
            switch tableViewSection {
            case .redditFeeds:
                self.showSubreddit(self.subreddits[indexPath.row])
            case .defaultFeeds:
                let listing = self.dataSource.listings[indexPath.row]
                self.showSubreddit(Subreddit.other(listing.displayName!))
            }
        }
    }
}
