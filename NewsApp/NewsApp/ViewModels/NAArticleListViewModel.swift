
import Foundation

class NAArticleListViewModel: NSObject {
    private(set) var articleViewModels = [NAArticleViewModel]()
    var title: String? = "Loading..."
    private let newsAPI = NewsAPI(apiKey: NewsAPIKey.apiKey);
    
    func getArticles(completed: @escaping (() -> ())) {
        self.newsAPI.getTopHeadlines(sources: bbcNewsTargetInfo.sourceKey) { [weak self] result in
            switch result {
            case .success(let articleList):
                if let article = articleList.first {
                    self?.title = article.source.name
                }
                self?.articleViewModels = articleList.compactMap(NAArticleViewModel.init)
            case .failure(_):
                fatalError()    // TODO: display alert with error
            }
            
            completed()
        }
    }
}
