
import UIKit
import RxSwift
import RxCocoa

class NAArticleDetailViewController: UIViewController {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    
    var articleViewModel: NAArticleViewModel!
    weak var delegate: NAArticleDelegate?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailConfiguration()
    }
    
    func setupDetailConfiguration() {
        self.articleViewModel.title.asObservable().bind(to: self.navigationItem.rx.title).disposed(by: disposeBag)
        self.articleViewModel.imageData.asObservable().bind(to: self.articleImage.rx.image).disposed(by: disposeBag)
        self.articleViewModel.descriptionText.asObservable().bind(to: self.articleDescription.rx.text).disposed(by: disposeBag)
        self.articleViewModel.content.asObservable().bind(to: self.articleContent.rx.text).disposed(by: disposeBag)
        
        self.articleViewModel.isFavourite.asObservable().subscribe(onNext: { favourite in
            if (favourite) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Icons.removeFromFavourite), style: .plain, target: self, action: #selector(self.removeFromFavourite))
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Icons.addToFavourite), style: .plain, target: self, action: #selector(self.addToFavourite))
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - User Interface Interaction

extension NAArticleDetailViewController {
    @objc func addToFavourite() {
        self.articleViewModel.addToFavourites()
        delegate?.addToFavourites(articleViewModel: self.articleViewModel)
    }
    
    @objc func removeFromFavourite() {
        self.articleViewModel.removeFromFavourites()
        delegate?.removeFromFavourites(articleViewModel: self.articleViewModel)
    }
}
