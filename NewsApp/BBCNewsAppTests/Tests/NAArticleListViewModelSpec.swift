
import Quick
import Nimble

@testable import BBCNewsApp

class NAArticleListViewModelSpec: QuickSpec {
    override func spec() {
        var newsAPI: NewsAPI!
        var newsProviderMock: NAProviderMock!
        var decoderMock: NADecoderMock!
        var sourceKey: String!
        
        beforeEach {
            newsProviderMock = NAProviderMock(apiKey: "key")
            decoderMock = NADecoderMock()
            
            newsAPI = NewsAPI(provider: newsProviderMock, decoder: decoderMock)
            sourceKey = "source1"
        }
    }
}
