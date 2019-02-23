import UIKit
import ImageService
import ListingService

class ListingTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var thumbnailImageView: NetworkImageView!

    static var reuseIdentifier: String {
        return "ListingTableViewCell"
    }
}

extension ListingTableViewCell: ListingDisplayable {
    func display(_ listing: Listing) {
        configureTitleText(with: listing)
        configureThumbnailImageView(with: listing)
        configureBodyText(with: listing)
    }
}

private extension ListingTableViewCell {
    func configureTitleText(with listing: Listing) {
        titleLabel.text = listing.title.stripHtml
    }

    func configureThumbnailImageView(with listing: Listing) {
        thumbnailImageView.isHidden = listing.thumbnailURL == nil
        thumbnailImageView.url = listing.thumbnailURL
    }

    func configureBodyText(with listing: Listing) {
        guard let selftext = listing.selftext  else {
            bodyLabel.isHidden = true
            return
        }

        bodyLabel.isHidden = selftext.isEmpty
        bodyLabel.text = selftext.stripHtml
    }
}
