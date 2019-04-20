
import Foundation

public enum NAError: Error {
    case unknown
    case unableToParse
    case requestFailed
    case invalidEndpointURL
    case serviceError(code: String, message: String)
}
