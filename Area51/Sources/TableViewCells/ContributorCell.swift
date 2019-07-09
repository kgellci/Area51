//
//  ContributorCell.swift
//  Area51
//
//  Created by Yon Montoto on 6/28/19.
//

import ImageService
import UIKit

class ContributorCell: UITableViewCell {
    @IBOutlet var contributorName: UILabel!
    @IBOutlet var contributionsLabel: UILabel!
    @IBOutlet var avatarImageView: NetworkImageView!

    static var reuseIdentifier: String {
        return "ContributorCell"
    }

    static var nib: UINib {
        return UINib(nibName: "ContributorCell", bundle: nil)
    }

}
