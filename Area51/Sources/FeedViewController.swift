import ListingService
import SafariServices
import UIKit

final class FeedViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: FeedViewModel!

    class func instantiateFromStoryboard(withSubreddit subreddit: Subreddit) -> FeedViewController {
        let storyboard = UIStoryboard.feed
        let feedViewController: FeedViewController = storyboard.viewControllerFrom(identifier: "FeedViewController")
        feedViewController.viewModel = FeedViewModel(with: subreddit)
        return feedViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension FeedViewController {
    func setup() {
        title = viewModel.subredditName
        setupTableView()
        bindViewModel()
    }

    func bindViewModel() {
        viewModel.updated = { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }

    func setupTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(refreshData),
                                            for: .valueChanged)

        tableView.register(ListingTableViewCell.nib,
                           forCellReuseIdentifier: ListingTableViewCell.reuseIdentifier)
    }

    @objc func refreshData() {
        viewModel.refreshListings()
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listingsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.loadMoreIfNeeded(currentIndex: indexPath.row)
        let cell: ListingTableViewCell = tableView.reusableCell(forIdentifier: ListingTableViewCell.reuseIdentifier)

        if let listing = viewModel.listing(at: indexPath.row) {
            cell.display(listing)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let listing = viewModel.listing(at: indexPath.row) {
            let safariViewController = SFSafariViewController(url: listing.url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
