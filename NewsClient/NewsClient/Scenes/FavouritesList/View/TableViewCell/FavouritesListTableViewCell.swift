//
//  FavouritesListTableViewCell.swift
//  NewsClient
//
//  Created by Admin on 14.09.21.
//

import UIKit

class FavouritesListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var urlToImageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    
    static let identifier = String(describing: FavouritesListTableViewCell.self)
    
}
