import UIKit

class ContributionController: UITableViewController {

    var listOfContributors = [Contributor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ContributorCell", bundle: nil), forCellReuseIdentifier: "ContributorCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            self.getContributors { (res) in
                switch res {
                case .success(let contributors):
                    contributors.forEach({ (contributor) in
                        self.listOfContributors.append(contributor)
                    })
                case .failure(let err):
                    print(err)
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
             self.tableView.reloadData()
        }
    }

    fileprivate func getContributors(completion: @escaping (Result<[Contributor], Error>) -> Void) {
        let request = "https://api.github.com/repos/kgellci/Area51/contributors?anon=1"
        guard let url = URL(string: request) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else { return }

            do {
                let contributors = try JSONDecoder().decode([Contributor].self, from: data)
                completion(.success(contributors))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfContributors.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContributorCell", for: indexPath) as! ContributorCell
        let contributors = listOfContributors[indexPath.item]

        cell.contributorName.text = (contributors.login != nil) ? contributors.login : contributors.name
        cell.contributionsLabel.text = "\(contributors.contributions) Contributions"

        return cell
    }
}
