import CoreAPI
import Foundation

public class Listing {
    public let title: String
    public let url: URL
    let fullServerID: String

    init?(json: JSON) {
        guard let innerData = json["data"] as? JSON,
            let title = innerData["title"] as? String,
            let urlString = innerData["url"] as? String,
            let fullServerID = innerData["name"] as? String else {
            return nil
        }

        self.title = title
        self.fullServerID = fullServerID
        self.url = URL(string: urlString)!
    }
}
