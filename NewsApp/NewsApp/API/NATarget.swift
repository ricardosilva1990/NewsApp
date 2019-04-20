
import Foundation

public enum NATarget {
    case topHeadlines(sources: String?)
}

private extension NATarget {
    func makeTopHeadlinesParameters(sources: String?) -> [String: String] {
        var parameters = [String: String]()
        
        if let source = sources {
            parameters["sources"] = source
        }
        parameters["sortBy"] = SortOptions.publishedAt.rawValue
        
        return parameters
    }
    
    func makeEndpoint(baseURL: String, path: String, parameters: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(string: "\(baseURL)\(path)") else { return nil }
        
        urlComponents.queryItems = parameters.map { name, value in
            return URLQueryItem(name: name, value: value)
        }
        
        return urlComponents.url
    }
}

extension NATarget: NATargetType {
    var baseURL: String {
        return "https://newsapi.org"
    }
    
    var path: String {
        switch self {
        case .topHeadlines(sources: _):
            return "/v2/top-headlines"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case let .topHeadlines(sources: sources):
            return makeTopHeadlinesParameters(sources: sources)
        }
    }
    
    var endpoint: URL? {
        return makeEndpoint(baseURL: self.baseURL, path: self.path, parameters: self.parameters)
    }
}


