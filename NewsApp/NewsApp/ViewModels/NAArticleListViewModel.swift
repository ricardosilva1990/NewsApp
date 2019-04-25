
import Foundation
import RxSwift
import RxCocoa
import Realm
import RealmSwift

typealias APIFailureHandler = (() -> ())

class NAArticleListViewModel {
    var articleViewModels: BehaviorRelay<[NAArticleViewModel]> = BehaviorRelay(value: [NAArticleViewModel]())
    
    var favouriteArticleViewModels: BehaviorRelay<[NAArticleViewModel]> = BehaviorRelay(value: [NAArticleViewModel]())
    
    private let newsAPI: NewsAPI?
    private let sourceKey: String?
    
    init(newsAPI: NewsAPI = NewsAPI(apiKey: NewsAPIKey.apiKey), sourceKey: String = NewsTargetInfo.sourceKey) {
        self.newsAPI = newsAPI
        self.sourceKey = sourceKey
    }
    
    func setup(errorHandler: @escaping APIFailureHandler) {
        self.newsAPI!.getTopHeadlines(sources: self.sourceKey!) { [weak self] result in
            switch result {
            case .success(let articleList):
                self?.articleViewModels.accept(articleList.compactMap { NAArticleViewModel(article: $0) } )
            case .failure(_):
                errorHandler()
            }
        }
    }
    
    func setupFavourites(realm: Realm? = try? Realm()) {
        self.favouriteArticleViewModels = BehaviorRelay(value: (realm?.objects(NAArticle.self).compactMap { NAArticleViewModel(article: $0) })!)
    }
}
