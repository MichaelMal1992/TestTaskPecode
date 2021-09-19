//
//  FilterNewsTableViewCell.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import UIKit

class FilterNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameFilteringLabel: UILabel!

    static let identifier = String(describing: FilterNewsTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
