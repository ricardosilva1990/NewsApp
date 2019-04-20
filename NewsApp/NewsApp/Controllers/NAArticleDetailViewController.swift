//
//  NAArticleDetailViewController.swift
//  NewsApp
//
//  Created by Ricardo Silva on 20/04/2019.
//  Copyright © 2019 Ricardo Silva. All rights reserved.
//

import UIKit

class NAArticleDetailViewController: UIViewController {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    
    var articleViewModel: NAArticleViewModel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = self.articleViewModel.title {
            self.navigationItem.title = title
        }
        
        if let data = self.articleViewModel.imageData {
            self.articleImage.image = UIImage(data: data)
        } else {
            self.articleImage.isHidden = true
        }
        
        if let desc = self.articleViewModel.descriptionText {
            self.articleDescription.text = desc
        } else {
            self.articleDescription.isHidden = true
        }
        
        if let cont = self.articleViewModel.content {
            self.articleContent.text = cont
        } else {
            self.articleContent.isHidden = true
        }
    }
}
