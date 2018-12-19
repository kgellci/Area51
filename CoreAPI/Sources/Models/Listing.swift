import Foundation

public class Listing {
    public let title: String

    init?(json: JSON) {
        guard let innerData = json["data"] as? JSON, let title = innerData["title"] as? String else {
            return nil
        }

        self.title = title
    }
}
