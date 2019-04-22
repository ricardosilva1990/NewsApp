
import Foundation
import Realm
import RealmSwift
import RxSwift
import RxCocoa

class NAArticleViewModel: NSObject {
    var title: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var imageData: BehaviorRelay<UIImage?> = BehaviorRelay(value: UIImage(named: bbcNewsTargetInfo.defaultImage))
    var descriptionText: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var content: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var source: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var isFavourite: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    init(article: NAArticle) {
        super.init()
        
        self.title = BehaviorRelay(value: article.title)
        self.descriptionText = BehaviorRelay(value: article.articleDescription)
        self.content = BehaviorRelay(value: article.content)
        self.source = BehaviorRelay(value: article.source?.name)
        
        if let imageData = article.imageData {
            self.imageData.accept(UIImage(data: imageData))
        }
        
        if let articleImage = self.imageData.value, articleImage == UIImage(named: bbcNewsTargetInfo.defaultImage) {
            if let imageURLString = article.urlToImage, let imageURL = URL(string: imageURLString) {
                let dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                    if let data = data {
                        self?.imageData.accept(UIImage(data: data))
                    }
                }
                dataTask.resume()
            }
        }
        
        let realm = try? Realm()
        self.isFavourite.accept(realm?.objects(NAArticle.self).filter("title = %@", article.title!).count != 0)
    }
}

//MARK: - Realm Add/Remove
extension NAArticleViewModel {
    func addToFavourites() {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(NAArticle(title: self.title.value, articleDescription: self.descriptionText.value, content: self.content.value, imageData: self.imageData.value?.pngData()))
            self.isFavourite.accept(true)
        }
    }

    func removeFomFavourites() {
        let realm = try? Realm()
        let article = realm?.objects(NAArticle.self).filter("title = %@", self.title.value!).first
        try? realm?.write {
            realm?.delete(article!)
            self.isFavourite.accept(false)
        }
    }
}
