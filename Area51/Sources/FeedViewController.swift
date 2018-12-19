import UIKit

final class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: ListingsDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupDataSource()
    }

    private func setupDataSource() {
        self.dataSource = ListingsDataSource(listingFeed: .popular)
        self.dataSource.updated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.listings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ListingCell")
        let listing = self.dataSource.listings[indexPath.row]
        cell.textLabel?.text = listing.title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
