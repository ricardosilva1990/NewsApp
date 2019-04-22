
import Foundation
import OHHTTPStubs

struct NetworkStub {
    static func successfulRequest(data: Data) {
        stub(condition: isHost("newsapi.org")) { _ in
            return OHHTTPStubsResponse(data: data, statusCode: 200, headers: ["Content-Type" : "application/json"])
        }
    }
    
    static func failureRequest() {
        stub(condition: isHost("newsapi.org")) { _ in
            return OHHTTPStubsResponse(error: NSError(domain: NSURLErrorDomain, code: 500, userInfo: nil))
        }
    }
    
    static func removeAllStubs() {
        OHHTTPStubs.removeAllStubs()
    }
}
