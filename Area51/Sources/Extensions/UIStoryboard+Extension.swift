import UIKit

extension UIStoryboard {
    func viewControllerFrom<T>(identifier: String) -> T {
        return self.instantiateViewController(withIdentifier: identifier) as! T // swiftlint:disable:this force_cast
    }
}
