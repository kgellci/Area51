import Foundation

public class Listing {
    public let title: String
    public let url: URL

    init?(json: JSON) {
        guard let innerData = json["data"] as? JSON, let title = innerData["title"] as? String,
            let urlString = innerData["url"] as? String else {
            return nil
        }

        self.title = title
        self.url = URL(string: urlString)!
    }
}
