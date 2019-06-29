import Foundation
import UIKit

struct Contributor: Decodable {
    var login: String?
    var name: String?
    var contributions: Int
}
