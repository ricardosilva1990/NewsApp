
import Foundation
import Realm
import RealmSwift

public class NASource: Object, Codable {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    
    convenience init(id: String?, name: String?) {
        self.init()
        self.id = id
        self.name = name
    }
    
    public required init() {
        super.init()
    }
    
    public required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    public required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

public class NAArticle: Object, Codable {
    @objc dynamic var source: NASource?
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var articleDescription: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var publishedAt: Date?
    @objc dynamic var content: String?
    
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
    
    convenience init(source: NASource?,
                     author: String?,
                     title: String?,
                     articleDescription: String?,
                     url: String,
                     urlToImage: String?,
                     publishedAt: Date,
                     content: String?,
                     imageData: Data?) {
        self.init()
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.imageData = imageData
    }
    
    convenience init(title: String?, articleDescription: String?, content: String?, imageData: Data?) {
        self.init()
        self.title = title
        self.articleDescription = articleDescription
        self.content = content
        self.imageData = imageData
    }
    
    public required init() {
        super.init()
    }
    
    public required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    public required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
