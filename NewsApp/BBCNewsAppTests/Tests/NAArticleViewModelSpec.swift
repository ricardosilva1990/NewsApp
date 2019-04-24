
import Quick
import Nimble
import Realm
import RealmSwift

@testable import BBCNewsApp

class NAArticleViewModelSpec: QuickSpec {
    override func spec() {
        var articleViewModelMock: NAArticleViewModel!
        var realmMock: Realm!
        
        beforeEach {
            realmMock = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: "articleViewModelSpec"))
            articleViewModelMock = NAArticleViewModel(article: NetworkData.NewsAPITopHeadlines.successTopHeadline,
                                                      realm: realmMock,
                                                      defaultImage: NetworkData.NewsAPITopHeadlines.defaultImage)
        }
        
        afterEach {
            try? realmMock?.write {
                realmMock?.deleteAll()
            }
        }
        
        describe("Get Title") {
            context("Successfully fills Title Variable") {
                it("Returns Title String") {
                    expect(articleViewModelMock.title.value) == NetworkData.NewsAPITopHeadlines.successTopHeadline.title
                }
            }
        }
        
        describe("Get Description Text") {
            context("Successfully fills Description Text Variable") {
                it("Returns Description Text String") {
                    expect(articleViewModelMock.descriptionText.value) == NetworkData.NewsAPITopHeadlines.successTopHeadline.articleDescription
                }
            }
        }
        
        describe("Get Content") {
            context("Successfully fills Content Variable") {
                it("Returns Content String") {
                    expect(articleViewModelMock.content.value) == NetworkData.NewsAPITopHeadlines.successTopHeadline.content
                }
            }
        }
        
        describe("Get Source") {
            context("Successfully fills Source Variable") {
                it("Returns Source String") {
                    expect(articleViewModelMock.source.value) == NetworkData.NewsAPITopHeadlines.successTopHeadline.source?.name
                }
            }
        }
        
        describe("Get Favourite") {
            context("Successfully fills Favourite Variable") {
                it("Returns Favourite Bool") {
                    expect(articleViewModelMock.isFavourite.value) == false
                }
                
                it("Realm is Empty") {
                    expect(realmMock?.objects(NAArticle.self).count) == 0
                }
            }
            describe("Realm Operations") {
                beforeEach {
                    articleViewModelMock.addToFavourites(realm: realmMock)
                }
                
                describe("Adds to Favourite") {
                    context("Successfully add the article to favourites") {
                        it("Article is added to Realm") {
                            expect(realmMock?.objects(NAArticle.self).count) == 1
                        }
                        
                        it("isFavourite Variable is updated") {
                            expect(articleViewModelMock.isFavourite.value) == true
                        }
                    }
                    
                    context("Fails to add a Second Time") {
                        it("Article is only inserted once to Realm") {
                            articleViewModelMock.addToFavourites(realm: realmMock)
                            expect(realmMock?.objects(NAArticle.self).count) != 2
                        }
                    }
                }
                
                describe("Removes from Favourites") {
                    beforeEach {
                        articleViewModelMock.removeFromFavourites(realm: realmMock)
                    }
                    
                    context("Successfully remove the article from favourites") {
                        it("Article is removed from Realm") {
                            expect(realmMock?.objects(NAArticle.self).count) == 0
                        }
                        
                        it("isFavourite Variable is updated") {
                            expect(articleViewModelMock.isFavourite.value) == false
                        }
                    }
                    
                    context("Fails to remove a Second Time") {
                        it("Article is only removed once to Realm") {
                            articleViewModelMock.removeFromFavourites(realm: realmMock)
                            expect(realmMock?.objects(NAArticle.self).count) == 0
                        }
                    }
                }
            }
        }
        
        describe("Get Image Data") {
            context("Successfully fills Image Data Variable") {
                it("Returns default image") {
                    expect(articleViewModelMock.imageData.value) == NetworkData.NewsAPITopHeadlines.defaultImage
                }
            }
        }
    }
}
