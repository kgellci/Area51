import ImageService
import SubredditService
import UIKit

class SubredditTableViewCell: UITableViewCell {
    @IBOutlet weak var customImageView: NetworkImageView!
    @IBOutlet weak var customLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

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
