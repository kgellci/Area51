//
//  SettingsViewController.swift
//  Area51
//
//  Created by Felix Förtsch on 15.01.19.
//

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
            guard let url = URL.init(string: changelogURL) else {
                fatalError()
            }
            present(SFSafariViewController.init(url: url), animated: true)
        default:
            print("default")
        }
    }
}
