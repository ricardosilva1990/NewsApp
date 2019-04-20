
import Foundation

typealias NAImageDownloadHandler = ((Data?, NAError?) -> ())

class NAArticleViewModel: NSObject {
    var title: String?
    var imageData: Data?
    var descriptionText: String?
    var content: String?
    
    
    private var urlToImage: URL?
    
    init(title: String?, urlToImage: URL?, descriptionText: String?, content: String?) {
        self.title = title
        self.urlToImage = urlToImage
        self.descriptionText = descriptionText
        self.content = content
    }
    
    init(article: NAArticle) {
        self.title = article.title
        self.urlToImage = article.urlToImage
        self.descriptionText = article.articleDescription
        self.content = article.content
    }
    
    func downloadImage(completion: @escaping NAImageDownloadHandler) {
        if let imageURL = self.urlToImage {
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
