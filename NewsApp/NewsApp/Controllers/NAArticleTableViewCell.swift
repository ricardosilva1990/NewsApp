
import UIKit
import RxSwift
import RxCocoa

class NAArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    
    func configureWithArticle(article: NAArticleViewModel) {
        article.title.asObservable().bind(to: self.articleTitle.rx.text).disposed(by: disposeBag)
        article.imageData.asObservable().bind(to: self.articleImage.rx.image).disposed(by: disposeBag)
    }
}
