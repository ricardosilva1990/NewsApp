
import Foundation

/**
 * The struct that handles the API request result
 **/
struct NAResponse: Codable {
    let status: String
    let code: String?
    let message: String?
    let totalResults: Int?
    let articles: [NAArticle]?
}

enum SortOptions: String {
    case relevancy      // articles more closely related to q come first
    case popularity     // articles from popular sources and publishers come first
    case publishedAt    // newest articles come first
}


