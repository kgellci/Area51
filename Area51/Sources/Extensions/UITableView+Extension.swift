import UIKit

extension UITableView {
    /// Dequeue a reusable cell of required type
    ///
    /// - Parameter identifier: The reuse identifier for the cell
    /// - Returns: A cell of the required type
    func reusableCell<T>(forIdentifier identifier: String) -> T {
        return self.dequeueReusableCell(withIdentifier: identifier) as! T // swiftlint:disable:this force_cast
    }
}
