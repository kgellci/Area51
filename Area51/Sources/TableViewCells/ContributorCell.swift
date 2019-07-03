//
//  ContributorCell.swift
//  Area51
//
//  Created by Yon Montoto on 6/28/19.
//

import UIKit

class ContributorCell: UITableViewCell {
    @IBOutlet var contributorName: UILabel!
    @IBOutlet var contributionsLabel: UILabel!

    static var reuseIdentifier: String {
        return "ContributorCell"
    }

    static var nib: UINib {
        return UINib(nibName: "ContributorCell", bundle: nil)
    }

}
