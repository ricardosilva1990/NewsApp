
import Quick
import Nimble
import OHHTTPStubs

@testable import BBCNewsApp

private class NADecoderMock: NADecoder {
    var error: NAError?
    var headlinesDecodeStub: [NAArticle]?
    
    override func decode(data: Data) throws -> [NAArticle] {
        if let error = error {
            throw error
        }
        
        guard let headlinesDecodeStub = headlinesDecodeStub else { return [] }
        return headlinesDecodeStub
    }
}

private class NAProviderMock: NAProvider {
    var requestParameters: (target: NATarget, completion: NAProviderRequestHandler?)?
    
    override func request(_ target: NATarget, completion: NAProviderRequestHandler?) -> URLSessionDataTask? {
        requestParameters = (target, completion)
        completion?(Data(), nil)
        
        return URLSessionDataTask()
    }
}

class NewsAPISpec: QuickSpec {
    override func spec() {
        var newsAPI: NewsAPI!
        var newsProviderMock: NAProviderMock!
        var decoderMock: NADecoderMock!
        
        beforeEach {
            newsProviderMock = NAProviderMock(apiKey: "key")
            decoderMock = NADecoderMock()
            
            newsAPI = NewsAPI(provider: newsProviderMock, decoder: decoderMock)
        }
        
        describe("Top Headlines Request") {
            describe("Calls NewsProvider Top Headlines") {
                it("Passes Parameters Correctly") {
                    newsAPI.getTopHeadlines(sources: "source", completion: { _ in })
                    let requestTarget = newsProviderMock.requestParameters!.target
                    
                    if case .topHeadlines(sources: "source") = requestTarget { } else {
                        fail("Wrong password passed")
                    }
                }
            }
            
            context("Successfully Gets Top Headlines") {
                it("Returns Top Headlines") {
                    decoderMock.headlinesDecodeStub = [NetworkData.NewsAPITopHeadlines.successTopHeadline]
                    
                    waitUntil(timeout: 1.0, action: { success in
                        newsAPI.getTopHeadlines(sources: nil, completion: { result in
                            switch result {
                            case .success(let articles):
                                expect(articles.count) == 1
                                expect(articles.first) == NetworkData.NewsAPITopHeadlines.successTopHeadline
                                success()
                            case .failure(_):
                                fail()
                            }
                        })
                    })
                }
            }
            
            context("Failes to Decode Headlines") {
                it("Returns Unable to Parse Error") {
                    decoderMock.error = .unableToParse
                    
                    newsAPI.getTopHeadlines(sources: nil, completion: { result in
                        if case .failure(.unableToParse) = result { } else {
                            fail("Wrong Error")
                        }
                    })
                }
            }
        }
    }
}
