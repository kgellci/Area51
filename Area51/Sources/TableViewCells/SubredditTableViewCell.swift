import ImageService
import SubredditService
import UIKit

class SubredditTableViewCell: UITableViewCell {
    @IBOutlet weak var customImageView: NetworkImageView!
    @IBOutlet weak var customLabel: UILabel!

    func displayCell(_ subreddit: Subreddit) {
        configureTitleText(with: subreddit)
        configureThumbnailImageView(with: subreddit)
    }

}

private extension SubredditTableViewCell {

    func configureTitleText(with subreddit: Subreddit) {
        customLabel.text = subreddit.displayName
    }

    func configureThumbnailImageView(with subreddit: Subreddit) {
        if let imageURL = subreddit.iconImgURL {
            customImageView.url = imageURL
        }

    }

}
