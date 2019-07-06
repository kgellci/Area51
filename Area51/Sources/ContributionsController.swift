import UIKit

class ContributionController: UITableViewController {

    var listOfContributors = [Contributor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ContributorCell.nib,
                           forCellReuseIdentifier: ContributorCell.reuseIdentifier)
        self.title = "Contributors"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Contributor.getContributors { (res) in
            DispatchQueue.main.async {
                switch res {
                case .success(let contributors):
                    contributors.forEach({ (contributor) in
                        self.listOfContributors.append(contributor)
                    })
                    self.tableView.reloadData()
                case .failure(let err):
                    print(err)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfContributors.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContributorCell = tableView.reusableCell(forIdentifier: ContributorCell.reuseIdentifier)
        let contributors = listOfContributors[indexPath.item]

        cell.contributorName.text = contributors.login ?? contributors.name
        cell.contributionsLabel.text = "\(contributors.contributions) Contributions"

        return cell
    }
}
