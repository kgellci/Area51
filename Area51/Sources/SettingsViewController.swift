import SafariServices
import UIKit

class SettingsViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let changelogURL = "https://github.com/kgellci/Area51/blob/master/CHANGELOG.md"
            presentSafariViewController(with: changelogURL)
        case 1:
            let contributorsURL = "https://github.com/kgellci/Area51/graphs/contributors"
            presentSafariViewController(with: contributorsURL)
        case 2:
            let githubURL = "https://github.com/kgellci/Area51"
            presentSafariViewController(with: githubURL)
        default:
            print("default")
        }
    }

    func presentSafariViewController(with urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid url.")
        }
        present(SFSafariViewController(url: url), animated: true)
    }
}
