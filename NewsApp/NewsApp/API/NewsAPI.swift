
import Foundation

public typealias NARequestHandler<T> = ((Result<[T], NAError>) -> ())

public class NewsAPI {
    private let provider: NAProvider
    private let decoder: NADecoder
    
    public init(apiKey: String) {
        self.provider = NAProvider(apiKey: apiKey)
        self.decoder = NADecoder()
    }
    
    init(provider: NAProvider, decoder: NADecoder) {
        self.provider = provider
        self.decoder = decoder
    }
    
    /**
     GETs the top headlines for the given parameters
     **/
    @discardableResult
    public func getTopHeadlines(sources: String? = nil, completion: @escaping NARequestHandler<NAArticle>) -> URLSessionDataTask? {
        let headlinesTarget = NATarget.topHeadlines(sources: sources)
        return provider.request(headlinesTarget, completion: { (data, error) in
            guard let data = data else {
                completion(.failure(error ?? .unknown))
                return
            }
            
            do {
                let result: [NAArticle] = try self.decoder.decode(data: data)
                completion(.success(result))
            } catch let error {
                completion(.failure( (error as? NAError) ?? .unknown ))
            }
            
        })
    }
}
