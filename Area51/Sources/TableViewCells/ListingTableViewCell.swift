import ListingService
import UIKit

class ListingTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
}

extension ListingTableViewCell: ListingDisplayable {
    func display(listing: Listing) {
        self.titleLabel.text = listing.title
    }
}
