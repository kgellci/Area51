import UIKit
import SafariServices

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let changelogURL = "https://github.com/kgellci/Area51/blob/master/CHANGELOG.md"
            guard let url = URL(string: changelogURL) else {
                fatalError()
            }
            present(SFSafariViewController.init(url: url), animated: true)
        default:
            print("default")
        }
    }
}
