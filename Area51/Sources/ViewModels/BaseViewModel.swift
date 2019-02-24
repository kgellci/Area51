import UIKit

class BaseViewModel {
    var isActive = false {
        didSet {
            if oldValue == true {
                return
            }
            if isActive {
                didBecomeActive()
            }
        }
    }

    internal func didBecomeActive () {}
}
