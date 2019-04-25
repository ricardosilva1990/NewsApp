
import Quick
import Nimble
import Realm
import RealmSwift

@testable import BBCNewsApp

class NAArticleListViewModelSpec: QuickSpec {
    override func spec() {
        var newsAPI: NewsAPI!
        var newsProviderMock: NAProviderMock!
        var decoderMock: NADecoderMock!
        var sourceKey: String!
        var articleListViewModelMock: NAArticleListViewModel!
        
        beforeEach {
            newsProviderMock = NAProviderMock(apiKey: "key")
            decoderMock = NADecoderMock()
            
            newsAPI = NewsAPI(provider: newsProviderMock, decoder: decoderMock)
            sourceKey = "source1"
            articleListViewModelMock = NAArticleListViewModel(newsAPI: newsAPI, sourceKey: sourceKey)
        }
        
        describe("Get ArticleListViewModels") {
            context("Successfully Get Articles") {
                it("Returns Array with 1 element that matches the JSON one") {
                    expect(articleListViewModelMock.articleViewModels.value.count) == 0
                    
                    decoderMock.headlinesDecodeStub = [NetworkData.NewsAPITopHeadlines.successTopHeadline]
                    
                    articleListViewModelMock.setup {
                        fail()
                    }
                    expect(articleListViewModelMock.articleViewModels.value.count) == 1
                    
                    let articleViewModel: NAArticleViewModel = articleListViewModelMock.articleViewModels.value.first!
                    
                    expect(articleViewModel.title.value) == NetworkData.NewsAPITopHeadlines.successTopHeadline.title
                }
            }
            
            context("Fails to decode articles") {
                it("Returns empty Array") {
                    decoderMock.error = .unableToParse
                    
                    articleListViewModelMock.setup {
                        expect(articleListViewModelMock.articleViewModels.value.count) == 0
                    }
                }
            }
        }
        
        describe("Get FavouriteArticleViewModels") {
            var realmMock: Realm!
            
            beforeEach {
                realmMock = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: "articleListViewModelSpec"))
            }
            
            afterEach {
                try? realmMock?.write {
                    realmMock?.deleteAll()
                }
            }
            
            context("Successfully Get Articles") {
                it("Fills Database with 1 favourite article that matches the ViewModel") {
                    expect(realmMock?.objects(NAArticle.self).count) == 0
                    
                    // simulates adding a favourite
                    try? realmMock?.write {
                        realmMock?.add(NetworkData.NewsAPITopHeadlines.favouriteArticle)
                    }
                    
                    expect(realmMock?.objects(NAArticle.self).count) == 1
                    
                    articleListViewModelMock.setupFavourites(realm: realmMock)
                    
                    let articleViewModel: NAArticleViewModel = articleListViewModelMock.favouriteArticleViewModels.value.first!
                    
                    expect(articleViewModel.title.value) == NetworkData.NewsAPITopHeadlines.favouriteArticle.title
                }
            }
        }
    }
}
