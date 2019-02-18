import ListingService
import UIKit

class SubredditsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let subreddits = Subreddit.allSubreddits()
    private var dataSource: ListingsDataSource! {
        didSet {
            self.dataSource.updated = { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
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
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
    }

    private func showSubreddit(_ subreddit: Subreddit) {
        let feedViewController = FeedViewController.instantiateFromStoryboard(withSubreddit: subreddit)
        self.splitViewController?.showDetailViewController(feedViewController.embeddedInNavigationController(),
                                                           sender: self)
    }
    @objc
    private func refreshData() {
        self.dataSource.refresh()
    }
}

extension SubredditsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Reddit Feeds"
        default:
            return "Default Subreddits"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.subreddits.count
        default:
            return self.dataSource.listings.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.dataSource.loadMoreIfNeeded(currentIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubredditCell")!
        if indexPath.section == 0 {
            cell.textLabel?.text = self.subreddits[indexPath.row].name
        } else {
            let listing = self.dataSource.listings[indexPath.row]
            print(listing.title)
            cell.textLabel?.text = listing.url.absoluteString
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.showSubreddit(self.subreddits[indexPath.row])
        } else {
            let listing = self.dataSource.listings[indexPath.row]
            print(listing.title)
            self.showSubreddit(Subreddit.other(listing.displayName!))
        }
    }
}
