
import Foundation

@testable import BBCNewsApp

extension DateFormatter {
    static var iso8601: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter
    }
}

struct NetworkData {
    struct NewsAPI {
        static let noApiKeyErrorJsonData =
        """
        {
            "status": "error",
            "code": "apiKeyMissing",
            "message": "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header."
        }
        """.data(using: .utf8)!
    }
    
    struct NewsAPITarget {
        static let topHeadlines = NATarget.topHeadlines(sources: nil)
    }
    
    struct NewsAPITopHeadlines {
        static let successTopHeadlineJsonData =
        """
        {
            "status": "ok",
            "totalResults": 1,
            "articles": [
                {
                    "source": {
                        "id": "1",
                        "name": "source1"
                    },
                    "author": "Author 1",
                    "title": "Title 1",
                    "description": "Article Description 1",
                    "url": "https://www.source1.com",
                    "urlToImage": "https://www.source1.com/source01.jpg",
                    "publishedAt": "2019-04-23T22:12:02Z",
                    "content": "Content 1"
                }
            ]
        }
        """.data(using: .utf8)!
        
        static let invalidTopHeadlineJsonData =
        """
        {
            "status": "ok",
            "totalResults": 1,
            "article": [
                {
                    "source": {
                        "id": "1",
                        "name": "source1"
                    },
                    "author": "Author 1",
                    "title": "Title 1",
                    "description": "Article Description 1",
                    "url": "https://www.source1.com",
                    "urlToImage": "https://www.source1.com/source01.jpg",
                    "publishedAt": "abcadsda",
                    "content": "Content 1"
                }
            ]
        }
        """.data(using: .utf8)!
        
        static let emptyTopHeadlinesJsonData =
        """
            "status": "ok",
            "totalResults": 0,
            "articles": []
        """.data(using: .utf8)!
        
        static let successTopHeadline = NAArticle(source: NASource(id: "1", name: "source1"),
                                                  author: "Author 1",
                                                  title: "Title 1",
                                                  articleDescription: "Article Description 1",
                                                  url: "https://www.source1.com",
                                                  urlToImage: "https://www.source1.com/source01.jpg",
                                                  publishedAt: DateFormatter.iso8601.date(from: "2019-04-23T22:12:02Z")!,
                                                  content: "Content 1",
                                                  imageData: nil)
        
        
    }
}
