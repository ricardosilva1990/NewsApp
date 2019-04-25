
import Foundation
import Realm
import RealmSwift
import RxSwift
import RxCocoa

class NAArticleViewModel {
    var title: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var imageData: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var descriptionText: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var content: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var source: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var isFavourite: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let defaultImage: UIImage!
    
    init(article: NAArticle,
         realm: Realm? = try? Realm(),
         defaultImage: UIImage? = UIImage(named: NewsTargetInfo.defaultImage)) {
        self.defaultImage = defaultImage
        
        self.title = BehaviorRelay(value: article.title)
        self.descriptionText = BehaviorRelay(value: article.articleDescription)
        self.content = BehaviorRelay(value: article.content)
        self.source = BehaviorRelay(value: article.source?.name)
        
        if let imageData = article.imageData {
            self.imageData.accept(UIImage(data: imageData))
        } else {
            self.imageData.accept(defaultImage)
        }
        
        if let articleImage = self.imageData.value, articleImage == defaultImage {
            if let imageURLString = article.urlToImage, let imageURL = URL(string: imageURLString) {
                let dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                    if let data = data {
                        self?.imageData.accept(UIImage(data: data))
                    }
                }
                dataTask.resume()
            }
        }
        
        self.isFavourite.accept(realm?.objects(NAArticle.self).filter("title = %@", article.title!).count != 0)
    }
}

//MARK: - Realm Add/Remove
extension NAArticleViewModel {
    func addToFavourites(realm: Realm? = try? Realm()) {
        guard !self.isFavourite.value else { return }
        try? realm?.write {
            let articleToAdd = NAArticle(title: self.title.value,
                                         articleDescription: self.descriptionText.value,
                                         content: self.content.value,
                                         imageData: self.imageData.value?.pngData())
            realm?.add(articleToAdd)
            self.isFavourite.accept(true)
        }
    }
    
    func removeFromFavourites(realm: Realm? = try? Realm()) {
        guard self.isFavourite.value else { return }
        let article = realm?.objects(NAArticle.self).filter("title = %@", self.title.value!).first
        try? realm?.write {
            realm?.delete(article!)
            self.isFavourite.accept(false)
        }
    }
}
