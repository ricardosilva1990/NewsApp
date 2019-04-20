
import Foundation

protocol NATargetType {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var endpoint: URL? { get }
}
