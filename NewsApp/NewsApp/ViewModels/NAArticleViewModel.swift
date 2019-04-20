
import Foundation

typealias NAImageDownloadHandler = ((Data?, NAError?) -> ())

class NAArticleViewModel: NSObject {
    var title: String?
    var imageData: Data?
    private var urlToImage: URL?
    
    init(title: String?, imageData: Data?, urlToImage: URL?) {
        self.title = title
        self.urlToImage = urlToImage
    }
    
    init(article: NAArticle) {
        self.title = article.title
        self.urlToImage = article.urlToImage
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
