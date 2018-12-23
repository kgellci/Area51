import SafariServices
import UIKit

final class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: ListingsDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupDataSource()
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.tableView.register(UINib(nibName: "ListingTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "ListingTableViewCell")
    }

    private func setupDataSource() {
        self.dataSource = ListingsDataSource(listingFeed: .popular)
        self.dataSource.updated = { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
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

        self.dataSource.loadMoreIFNeeded(currendIndexPath: indexPath)
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
