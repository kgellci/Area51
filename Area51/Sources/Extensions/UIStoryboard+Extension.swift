import UIKit

extension UIStoryboard {
    func viewControllerFrom<T>(identifier: String) -> T {
        return self.instantiateViewController(withIdentifier: identifier) as! T // swiftlint:disable:this force_cast
    }

    class var feed: UIStoryboard {
        return UIStoryboard(name: "Feed", bundle: nil)
    }

    class var settings: UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
}
