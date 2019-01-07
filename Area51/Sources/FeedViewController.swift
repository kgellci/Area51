import ListingService
import SafariServices
import UIKit

final class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var dataSource: ListingsDataSource! {
        didSet {
            self.dataSource.updated = { [weak self] in
                self?.endRefreshingOnTableView()
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
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        setupTableViewRefreshControl()
        registerTableViewCells()
    }

    private func setupTableViewRefreshControl () {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    private func registerTableViewCells () {
        tableView.register(UINib(nibName: "ListingTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ListingTableViewCell")

        tableView.register(UINib(nibName: "ListingThumbnailTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ListingThumbnailTableViewCell")
    }

    @objc
    private func refreshData() {
        dataSource.refresh()
    }

    private func endRefreshingOnTableView () {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.listings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.dataSource.loadMoreIfNeeded(currentIndex: indexPath.row)
        let listing = self.dataSource.listings[indexPath.row]

        let cell: UITableViewCell
        if listing.thumbnailURL == nil {
            cell = tableView.reusableCell(forIdentifier: "ListingTableViewCell")
        } else {
            cell = tableView.reusableCell(forIdentifier: "ListingThumbnailTableViewCell")
        }

        (cell as? ListingDisplayable)?.display(listing: listing)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let listing = self.dataSource.listings[indexPath.row]
        let safariViewController = SFSafariViewController(url: listing.url)

        present(safariViewController, animated: true, completion: nil)
    }
}
