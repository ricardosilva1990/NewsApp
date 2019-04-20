
import Foundation

class NADecoder {
    lazy private var dateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter
    }()
    
    func decode(data: Data) throws -> [NAArticle] {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = dateDecodingStrategy()
        
        let response = try? jsonDecoder.decode(NAResponse.self, from: data)
        
        if let code = response?.code, let message = response?.message {
            throw NAError.serviceError(code: code, message: message)
        }
        
        guard let articles = response?.articles else { throw NAError.unableToParse }
        return articles 
    }
}

private extension NADecoder {
    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy {
        return .custom({ [weak self] decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            guard let date = self?.dateFormat.date(from: dateStr) else { throw NAError.unableToParse }
            return date
        })
    }
}
