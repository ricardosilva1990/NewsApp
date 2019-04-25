
import Quick
import Nimble
import OHHTTPStubs

@testable import BBCNewsApp

private class URLSessionDataTaskMock: URLSessionDataTask {
    var resumeCalled = false
    
    override func resume() {
        resumeCalled = true
    }
}

private class URLSessionMock: URLSession {
    var dataTask: (request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void)?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskMock {
        dataTask = (request, completionHandler)
        return URLSessionDataTaskMock()
    }
}

class NAProviderSpec: QuickSpec {
    override func spec() {
        var urlSessionMock: URLSessionMock!
        var newsProvider: NAProvider!
        
        afterEach {
            NetworkStub.removeAllStubs()
        }
        
        describe("Request") {
            beforeEach {
                urlSessionMock = URLSessionMock()
                newsProvider = NAProvider(apiKey: "key", urlSession: urlSessionMock)
            }
            
            it("Has X-Api-Key Header") {
                newsProvider.request(NetworkData.NewsAPITarget.topHeadlines, completion: nil)
                expect(urlSessionMock.dataTask?.request.value(forHTTPHeaderField: "X-Api-Key")) == "key"
            }
            
            it("Resumes Data Task") {
                let dataTask = newsProvider.request(NetworkData.NewsAPITarget.topHeadlines, completion: nil) as! URLSessionDataTaskMock
                
                expect(dataTask.resumeCalled) == true
            }
        }
        
        describe("Requests Top Headlines") {
            beforeEach {
                newsProvider = NAProvider(apiKey: "key")
            }
            
            context("Success") {
                it("Returns Data") {
                    NetworkStub.successfulRequest(data: NetworkData.NewsAPITopHeadlines.successTopHeadlineJsonData)
                    
                    waitUntil(timeout: 1.0) { success in
                        newsProvider.request(NetworkData.NewsAPITarget.topHeadlines) { data, error in
                            expect(data) == NetworkData.NewsAPITopHeadlines.successTopHeadlineJsonData
                            expect(error).to(beNil())
                            success()
                        }
                    }
                }
            }
            
            context("Failure") {
                it("Returns Error") {
                    NetworkStub.failureRequest()
                    
                    waitUntil(timeout: 1.0) { success in
                        newsProvider.request(NetworkData.NewsAPITarget.topHeadlines) { data, error in
                            expect(data).to(beNil())
                            if case .requestFailed = error! {
                                success()
                            } else {
                                fail("Wrong Error Returned")
                            }
                        }
                    }
                }
            }
        }
    }
}
