
import Foundation
import LocalAuthentication

enum NABiometricType {
    case none
    case touchID
    case faceID
}

typealias NAUserAuthenticationCompletionHandler = ((String?) -> ())

struct NABiometricIDAuth {
    let context = LAContext()
    var loginReason = "Logging in with Touch ID"
    
    func canEvaluatePolicy() -> Bool {
        var error: NSError?
        let hasTouchID = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        return hasTouchID || (error?.code != LAError.biometryNotAvailable.rawValue && error?.code != LAError.biometryNotEnrolled.rawValue)
        
    }
    
    func biometricType() -> NABiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        default:
            return .none
        }
    }
    
    func authenticateUser(completion: @escaping NAUserAuthenticationCompletionHandler) {
        guard canEvaluatePolicy() else {
            completion("Biometrics not available")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { success, evaluateError in
            if success {
                DispatchQueue.main.async {
                    // user authentication success
                    completion(nil)
                }
            } else {
                // error
                completion("Couldn't continue with authentication. Please try again.")
                
            }
        }
    }
}
