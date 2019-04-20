
import Foundation

public struct NAArticle: Codable {
    let source: NASource
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: URL
    let urlToImage: URL?
    let publishedAt: Date
    let content: String?
    
    public struct NASource: Codable {
        let id: String?
        let name: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case articleDescription = "description"
        case url
        case urlToImage
        case publishedAt
        case content
    }
    
    public init(source: NASource,
                author: String?,
                title: String?,
                articleDescription: String?,
                url: URL,
                urlToImage: URL?,
                publishedAt: Date,
                content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}
