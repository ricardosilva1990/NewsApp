
import Foundation

@testable import BBCNewsApp

class NAProviderMock: NAProvider {
    var requestParameters: (target: NATarget, completion: NAProviderRequestHandler?)?
    
    override func request(_ target: NATarget, completion: NAProviderRequestHandler?) -> URLSessionDataTask? {
        requestParameters = (target, completion)
        completion?(Data(), nil)
        
        return URLSessionDataTask()
    }
}
