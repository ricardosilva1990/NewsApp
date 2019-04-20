
import Foundation
import Realm
import RealmSwift

typealias NAImageDownloadHandler = ((Data?, NAError?) -> ())

class NAArticleViewModel: NSObject {
    var title: String?
    var imageData: Data?
    var descriptionText: String?
    var content: String?
    var isFavourite: Bool = false

    private let article: NAArticle
    
    private var urlToImage: String?
    
//    let realm = try? Realm()
    
//    init(title: String?, urlToImage: String?, descriptionText: String?, content: String?, isFavourite: Bool) {
//        self.title = title
//        self.urlToImage = urlToImage
//        self.descriptionText = descriptionText
//        self.content = content
//        self.isFavourite = isFavourite
//    }
    
    init(article: NAArticle) {
        self.article = article
        
        self.title = article.title
        self.urlToImage = article.urlToImage
        self.descriptionText = article.articleDescription
        self.content = article.content
        
        if let title = article.title {
            do {
                let realm = try Realm()
                let predicate = NSPredicate(format: "title = %@", title)
                self.isFavourite = realm.objects(NAArticle.self).filter(predicate).count != 0
            } catch {
                self.isFavourite = false
            }
        } else {
            self.isFavourite = false
        }
    }
}

// MARK: - Image URL to Data

extension NAArticleViewModel {
    func downloadImage(completion: @escaping NAImageDownloadHandler) {
        if let imageURLString = self.urlToImage, let imageURL = URL(string: imageURLString) {
            let dataTask = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data {
                    self.imageData = data
                    completion(data, nil)
                }
                completion(nil, .requestFailed)
            }
            dataTask.resume()
        } else {
            completion(nil, .unknown)
        }
    }
}

// MARK: - Realm Interaction

extension NAArticleViewModel {
    func addToFavourites() {
        do {
            let realm = try Realm()
            try? realm.write {
                realm.add(self.article)
            }
            self.isFavourite = true
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func removeFomFavourites() {
        do {
            let realm = try Realm()
            try? realm.write {
                realm.delete(self.article)
            }
            self.isFavourite = false
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
