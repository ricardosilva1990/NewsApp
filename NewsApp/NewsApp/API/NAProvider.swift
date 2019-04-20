
import Foundation

typealias NAProviderRequestHandler = ((Data?, NAError?) -> ())

public class NAProvider {
    private let apiKey: String
    private let urlSession: URLSession
    
    init(apiKey: String, urlSession: URLSession = URLSession.shared) {
        self.apiKey = apiKey
        self.urlSession = urlSession
    }
    
    func request(_ target: NATarget, completion: NAProviderRequestHandler?) -> URLSessionDataTask? {
        guard let urlRequest = makeURLRequest(with: target) else {
            completion?(nil, .invalidEndpointURL)
            return nil
        }
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                completion?(data, nil)
                return
            }
            
            completion?(nil, .requestFailed)
        }
        
        dataTask.resume()
        return dataTask
    }
    
    func makeURLRequest(with target: NATarget) -> URLRequest? {
        guard let url = target.endpoint else { return nil }
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        return request
    }
}
