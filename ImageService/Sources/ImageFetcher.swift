import UIKit

public struct ImageFetcher {
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }()

    private static var currentDownloads = [URL: [ImageDownloadCompletion]]()

    public typealias ImageDownloadCompletion = (UIImage?, URL) -> Void

    /// Will download image data from a url and execute a completion handler when finished.
    /// If an image for a given url has already been downloaded and cached, it will return the cached version.
    ///
    /// - Parameters:
    ///   - url: The url of the image.
    ///   - completion: The completion handler returning a UIImage and the url from which it was fetched.
    public static func image(forURL url: URL, completion: @escaping ImageDownloadCompletion) {
        if self.currentDownloads.keys.contains(url) {
            self.currentDownloads[url]?.append(completion)
            return
        }

        self.currentDownloads[url] = [completion]
        self.session.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                let image: UIImage? = data.flatMap(UIImage.init)
                self.currentDownloads[url]?.forEach { $0(image, url) }
                self.currentDownloads.removeValue(forKey: url)
            }
        }.resume()
    }
}
