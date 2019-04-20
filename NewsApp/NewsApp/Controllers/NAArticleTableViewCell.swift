//
//  NAArticleTableViewCell.swift
//  NewsApp
//
//  Created by Ricardo Silva on 20/04/2019.
//  Copyright © 2019 Ricardo Silva. All rights reserved.
//

import UIKit

class NAArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
