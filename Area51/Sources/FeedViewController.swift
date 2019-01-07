import ListingService
import SafariServices
import UIKit

final class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var tableViewDatasource: TableViewDataSource<Listing>?
    private var dataSource: ListingsDataSource!

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
        refreshData()
    }

    private func setupTableView() {
        tableView.delegate = self
        setupTableViewRefreshControl()
        registerTableViewCells()
    }

    private func setupTableViewRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    private func registerTableViewCells () {
        tableView.register(ListingThumbnailTableViewCell.nib(),
                           forCellReuseIdentifier: ListingThumbnailTableViewCell.reuseIdentifier())
    }

    private func loadTableViewDataSource(with listings: [Listing]) {
        tableViewDatasource = TableViewDataSource.make(for: listings)
        tableView.dataSource = tableViewDatasource
        tableView.reloadData()
    }

    @objc
    private func refreshData() {
        dataSource.refresh { [weak self] (listings) in
            if let listings = listings {
                self?.loadTableViewDataSource(with: listings)
            }
        }
    }

    private func endRefreshingOnTableView() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}

extension FeedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let listing = self.dataSource.listings[indexPath.row]
        let safariViewController = SFSafariViewController(url: listing.url)

        present(safariViewController, animated: true, completion: nil)
    }
}
