
import UIKit

class NAArticleDetailViewController: UIViewController {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    
    var articleViewModel: NAArticleViewModel! = nil
    
    var addFavouriteButtonItem: UIBarButtonItem!
    var removeFavouriteButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFavouriteButtonItem = UIBarButtonItem(image: UIImage(named: Icons.addToFavourite), style: .plain, target: self, action: #selector(addToFavourite))
        removeFavouriteButtonItem = UIBarButtonItem(image: UIImage(named: Icons.removeFromFavourite), style: .plain, target: self, action: #selector(removeFromFavourite))
        
        self.navigationItem.rightBarButtonItem = articleViewModel.isFavourite ? removeFavouriteButtonItem : addFavouriteButtonItem
        
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

// MARK: - User Interface Interaction

extension NAArticleDetailViewController {
    @objc func addToFavourite() {
        self.articleViewModel.addToFavourites()
        self.navigationItem.rightBarButtonItem = self.removeFavouriteButtonItem
    }
    
    @objc func removeFromFavourite() {
        self.articleViewModel.removeFomFavourites()
        self.navigationItem.rightBarButtonItem = self.addFavouriteButtonItem
    }
}
