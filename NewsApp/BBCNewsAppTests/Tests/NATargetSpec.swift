
import Nimble
import Quick

@testable import BBCNewsApp

class NATargetSpec: QuickSpec {
    override func spec() {
        describe("News API") {
            it("baseURL") {
                expect(NetworkData.NewsAPITarget.topHeadlines.baseURL) == "https://newsapi.org"
            }
        }
        
        describe("Top Headlines") {
            it("Has Path") {
                expect(NetworkData.NewsAPITarget.topHeadlines.path) == "/v2/top-headlines"
            }
            
            describe("Parameters") {
                context("When Sources Parameters Doesn't Have Items") {
                    it("Sets no Sources Parameter") {
                        let topHeadlines = NATarget.topHeadlines(sources: nil)
                        expect(topHeadlines.parameters.contains(where: { $0.key == "sources" })) == false
                    }
                }
                
                context("When Sources Parameters Has One Item") {
                    it("Sets a single Source Parameter") {
                        let topHeadlines = NATarget.topHeadlines(sources: "source")
                        expect(topHeadlines.parameters["sources"]) == "source"
                    }
                }
            }
        }
        
        describe("Endpoint") {
            it("Sets Sources Parameter When Available") {
                let topHeadlines = NATarget.topHeadlines(sources: "source")
                expect(topHeadlines.endpoint) == URL(string: "https://newsapi.org/v2/top-headlines?sources=source&sortBy=publishedAt")
            }
        }
    }
}
