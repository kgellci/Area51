import ImageService
import ListingService
import UIKit

class ListingTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var subredditLabel: UILabel!
    @IBOutlet private var thumbnailImageView: NetworkImageView!

    static var reuseIdentifier: String {
        return "ListingTableViewCell"
    }

    static var nib: UINib {
        return UINib(nibName: "ListingTableViewCell", bundle: nil)
    }
}

extension ListingTableViewCell: ListingDisplayable {
    func display(_ listing: Listing) {
        configureTitleText(with: listing)
        configureThumbnailImageView(with: listing)
        configureSubredditLabel(with: listing)
        configureBodyText(with: listing)
    }
}

private extension ListingTableViewCell {
    func configureTitleText(with listing: Listing) {
        titleLabel.text = listing.title
    }

    func configureThumbnailImageView(with listing: Listing) {
        thumbnailImageView.isHidden = listing.thumbnailURL == nil
        thumbnailImageView.url = listing.thumbnailURL
    }

    func configureSubredditLabel(with listing: Listing) {
        guard let subredditName = listing.subredditName  else {
            subredditLabel.isHidden = true
            return
        }

        subredditLabel.isHidden = subredditName.isEmpty
        subredditLabel.text = subredditName.strippedHtml
    }

    func configureBodyText(with listing: Listing) {
        guard let selfText = listing.selfText  else {
            bodyLabel.isHidden = true
            return
        }

        bodyLabel.isHidden = selfText.isEmpty
        bodyLabel.text = selfText
    }
}
