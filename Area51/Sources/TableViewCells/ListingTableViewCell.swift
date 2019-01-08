import ImageService
import ListingService
import UIKit

class ListingTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: NetworkImageView!
    @IBOutlet private var thumbnailImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var titleLabelLeadingToThumbnailConstring: NSLayoutConstraint!
    @IBOutlet private var thumbnailImageViewHeightConstraint: NSLayoutConstraint!

    private var listing: Listing!

    override func prepareForReuse() {
        self.thumbnailImageView?.image = nil
    }

    class func reuseIdentifier() -> String {
        return "ListingTableViewCell"
    }

    class func nib() -> UINib {
        return UINib.init(nibName: "ListingTableViewCell", bundle: nil)
    }
}

extension ListingTableViewCell {

    func configure(_ listing: Listing) {
        self.listing = listing

        titleLabel.text = listing.title
        configureThumbnailImageView()
    }
}

extension ListingTableViewCell {

    private func configureThumbnailImageView () {
        thumbnailImageView.isHidden = shouldHideThumbnail()
        thumbnailImageView.url = listing.thumbnailURL
        configureThumbnailImageViewConstraints()
    }

    private func configureThumbnailImageViewConstraints() {
        thumbnailImageViewWidthConstraint.constant = shouldHideThumbnail() ? 0 : 80
        titleLabelLeadingToThumbnailConstring.constant = shouldHideThumbnail() ? 0 : 8
        thumbnailImageViewHeightConstraint.constant = shouldHideThumbnail() ? 0 : 80
    }

    private func shouldHideThumbnail () -> Bool {
        return listing.thumbnailURL == nil
    }
}
