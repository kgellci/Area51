import ImageService
import ListingService
import UIKit

class ListingThumbnailTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var thumbnailImageView: NetworkImageView!

    override func prepareForReuse() {
        self.thumbnailImageView?.image = nil
    }
}

extension ListingThumbnailTableViewCell: ListingDisplayable {
    func display(listing: Listing) {
        self.titleLabel.text = listing.title
        self.thumbnailImageView.url = listing.thumbnailURL
    }
}
