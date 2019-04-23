
import Nimble
import Quick

@testable import BBCNewsApp

class NADecoderSpec: QuickSpec {
    override func spec() {
        var decoder: NADecoder!
        
        beforeEach {
            decoder = NADecoder()
        }
        
        describe("Article JSON Decoding") {
            context("When Server Returns Error") {
                it("Throws Service Error") {
                    expect { try decoder.decode(data: NetworkData.NewsAPI.noApiKeyErrorJsonData) as [NAArticle] }
                    .to(throwError(NAError.serviceError(code: "apiKeyMissing", message: "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header.")))
                }
            }
            
            context("When Valid Data") {
                it("Returns Articles") {
                    expect { try decoder.decode(data: NetworkData.NewsAPITopHeadlines.successTopHeadlineJsonData) as [NAArticle] } == [NetworkData.NewsAPITopHeadlines.successTopHeadline]
                }
            }
            
            context("When Invalid Data") {
                it("Throws Unable to Parse Error") {
                    expect { try decoder.decode(data: NetworkData.NewsAPITopHeadlines.invalidTopHeadlineJsonData) as [NAArticle] }
                    .to(throwError(NAError.unableToParse))
                }
            }
            
            context("When Empty Data") {
                it("Throws Unable to PArse Error") {
                    expect { try decoder.decode(data: NetworkData.NewsAPITopHeadlines.emptyTopHeadlinesJsonData) as [NAArticle] }
                    .to(throwError(NAError.unableToParse))
                }
            }
        }
    }
}
