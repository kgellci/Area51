import UIKit

public class NetworkImageView: UIImageView {
    /// The url of the image to display.
    /// Setting the url will trigger the image to be fetched and displayed asynchronously.
    public var url: URL? {
        didSet {
            self.loadImageIfNeeded()
        }
    }

    private func loadImageIfNeeded() {
        guard let url = url else {
            self.image = nil
            return
        }

        ImageFetcher.image(forURL: url) { [weak self] (image, url) in
            if url == self?.url {
                self?.image = image
            }
        }
    }
}
