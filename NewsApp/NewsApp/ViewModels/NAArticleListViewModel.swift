
import Foundation
import RxSwift
import RxCocoa
import Realm
import RealmSwift

class NAArticleListViewModel {
    var articleViewModels: BehaviorRelay<[NAArticleViewModel]> = BehaviorRelay(value: [NAArticleViewModel]())
    
    lazy var favouriteArticleViewModels: BehaviorRelay<[NAArticleViewModel]> = {
        let realm = try? Realm()
        return BehaviorRelay(value: (realm?.objects(NAArticle.self).compactMap(NAArticleViewModel.init))!)
    }()
    
    private let newsAPI: NewsAPI?
    private let sourceKey: String?
    
    init(newsAPI: NewsAPI = NewsAPI(apiKey: NewsAPIKey.apiKey), sourceKey: String = NewsTargetInfo.sourceKey) {
        self.newsAPI = newsAPI
        self.sourceKey = sourceKey
    }
    
    func setup() {
        self.newsAPI!.getTopHeadlines(sources: self.sourceKey!) { [weak self] result in
            switch result {
            case .success(let articleList):
                self?.articleViewModels.accept(articleList.compactMap(NAArticleViewModel.init))
            case .failure(_):
                break
            }
        }
    }
}
