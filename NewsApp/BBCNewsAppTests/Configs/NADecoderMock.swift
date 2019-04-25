
import Foundation

@testable import BBCNewsApp

class NADecoderMock: NADecoder {
    var error: NAError?
    var headlinesDecodeStub: [NAArticle]?
    
    override func decode(data: Data) throws -> [NAArticle] {
        if let error = error {
            throw error
        }
        
        guard let headlinesDecodeStub = headlinesDecodeStub else { return [] }
        return headlinesDecodeStub
    }
}
