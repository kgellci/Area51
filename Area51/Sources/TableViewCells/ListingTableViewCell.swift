import UIKit
import ImageService
import ListingService

class ListingTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: NetworkImageView!

    static var reuseIdentifier: String {
        return "ListingTableViewCell"
    }
}

extension ListingTableViewCell: ListingDisplayable {
    func display(_ listing: Listing) {
        configureTitleText(with: listing)
        configureThumnailImage(with: listing)
        configureBodyText(with: listing)
    }
}

private extension ListingTableViewCell {
    func configureTitleText(with listing: Listing) {
        titleLabel.text = listing.title.stripHtml
    }

    func configureThumnailImage(with listing: Listing) {
        thumbnailImageView.isHidden = listing.thumbnailURL == nil
        thumbnailImageView.url = listing.thumbnailURL
    }

    func configureBodyText(with listing: Listing) {
        bodyLabel.isHidden = listing.selftext.isEmpty
        bodyLabel.text = listing.selftext.stripHtml
    }
}
