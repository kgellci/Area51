import ImageService
import ListingService
import UIKit

class ListingThumbnailTableViewCell: UITableViewCell {

    @IBOutlet private var thumbnailImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: NetworkImageView!

    private var listing: Listing!

    override func prepareForReuse() {
        self.thumbnailImageView?.image = nil
    }

    static func reuseIdentifier() -> String {
        return "ListingThumbnailTableViewCell"
    }

    static func nib() -> UINib {
        return UINib.init(nibName: "ListingThumbnailTableViewCell", bundle: nil)
    }
}

extension ListingThumbnailTableViewCell: ListingDisplayable {
    func display(listing: Listing) {
        self.titleLabel.text = listing.title
        self.thumbnailImageView.url = listing.thumbnailURL
    }
}

extension ListingThumbnailTableViewCell {

    func configure(_ listing: Listing) {
        self.listing = listing

        titleLabel.text = listing.title
        configureThumbnailImageView()
    }

    private func configureThumbnailImageView () {
        thumbnailImageView.isHidden = shouldHideThumbnail()
        thumbnailImageViewWidthConstraint.constant = shouldHideThumbnail() ? 0 : 80
        thumbnailImageView.url = listing.thumbnailURL
    }

    private func shouldHideThumbnail () -> Bool {
        return listing.thumbnailURL == nil
    }
}
