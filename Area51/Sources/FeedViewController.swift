import ListingService
import SafariServices
import UIKit

final class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: ListingsDataSource! {
        didSet {
            self.dataSource.updated = { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }

    class func instantiateFromStoryboard(withSubreddit subreddit: Subreddit) -> FeedViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedViewController: FeedViewController = storyboard.viewControllerFrom(identifier: "FeedViewController")
        feedViewController.dataSource = ListingsDataSource(subreddit: subreddit)
        feedViewController.title = subreddit.name
        return feedViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.tableView.register(UINib(nibName: "ListingTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "ListingTableViewCell")
    }

    @objc
    private func refreshData() {
        self.dataSource.refresh()
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.listings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell")
            as? ListingTableViewCell else {
                return UITableViewCell()
        }

        self.dataSource.loadMoreIfNeeded(currentIndex: indexPath.row)
        let listing = self.dataSource.listings[indexPath.row]
        cell.titleLabel?.text = listing.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let listing = self.dataSource.listings[indexPath.row]
        let safariViewController = SFSafariViewController(url: listing.url)
        self.present(safariViewController, animated: true, completion: nil)
    }
}
