import UIKit

extension UIViewController {
    func embeddedInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
