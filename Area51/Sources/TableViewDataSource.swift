//
//  TableViewDataSource.swift
//  Area51
//
//  Created by Robert Clegg on 2019/01/07.
//

import UIKit

/**
 I'm personally not a fan of  doing this import.
 However it was needed to get access to the Listing object

 Maybe we could look at doing this differently.
 Suggestion would be to not make services static libraries and
 make them part of the main target - otherwise we will need this import every time
 we need access to Library class or any other model class related listings (or the relevant service) to it.

 Will need to discussed some more
 */
import ListingService

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {

    typealias CellConfigurator = (Model, UITableViewCell) -> Void

    public var models: [Model]?

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator

    init(models: [Model]?,
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {

        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        if let model = models?[indexPath.row] {
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

            cellConfigurator(model, cell)
        }
        return cell
    }
}

extension TableViewDataSource where Model == Listing {

    static func make(for listings: [Listing]?) -> TableViewDataSource {

        return TableViewDataSource(models: listings,
                                   reuseIdentifier: ListingTableViewCell.reuseIdentifier(),
                                   cellConfigurator: { (listing, cell) in

                                    let listingCell = cell as? ListingTableViewCell
                                    listingCell?.configure(listing)
        })
    }
}
