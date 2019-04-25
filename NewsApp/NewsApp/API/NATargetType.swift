
import Foundation

/**
 * The configuration expected for all the urls
 **/
protocol NATargetType {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var endpoint: URL? { get }
}
