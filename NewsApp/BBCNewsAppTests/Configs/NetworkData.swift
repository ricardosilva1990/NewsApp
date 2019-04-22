
import Foundation

@testable import BBCNewsApp

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
                        "id": "bbc-news",
                        "name": "BBC News"
                    },
                    "author": "BBC News",
                    "title": "Herman Cain withdraws Federal Reserve bid",
                    "description": "President Trump tweeted that he would respect Mr Cain's wishes and not pursue the nomination.",
                    "url": "http://www.bbc.co.uk/news/world-us-canada-48017273",
                    "urlToImage": "https://ichef.bbci.co.uk/news/1024/branded_news/15577/production/_106551478_gettyimages-137361799.jpg",
                    "publishedAt": "2019-04-22T18:26:53Z",
                    "content": "Image copyrightGetty/Mark WilsonImage caption\r\n Herman Cain made a bid for the Republican presidential nomination in 2012\r\nFormer Republican presidential hopeful Herman Cain withdrew his name for a seat on the Federal Reserve Board, US President Donald Trump … [+1985 chars]"
                }
            ]
        }
        """.data(using: .utf8)!
        
        static let successTopHeadline = NAArticle(source: NASource(id: "1", name: "source1"),
                                                  author: "Author 1",
                                                  title: "Title 1",
                                                  articleDescription: "Article Description 1",
                                                  url: "https://www.source1.com",
                                                  urlToImage: "https://www.source1.com/source01.jpg",
                                                  publishedAt: Date(),
                                                  content: "Content 1",
                                                  imageData: URL(string: "https://www.source1.com/source01.jpg")?.dataRepresentation)
        
        
    }
}
