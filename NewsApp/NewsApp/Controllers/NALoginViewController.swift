
import UIKit

class NALoginViewController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idButton: UIButton!
    
    let biometricIDAuth = NABiometricIDAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display different labels and buttons based on the type of biometrics configured on the device
        switch biometricIDAuth.biometricType() {
        case .faceID:
            self.idLabel.text = "Log in with Face ID"
            self.idButton.setImage(UIImage(named: Icons.faceId), for: .normal)
        default:
            self.idLabel.text = "Log in with Touch ID"
            self.idButton.setImage(UIImage(named: Icons.touchId), for: .normal)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if biometricIDAuth.canEvaluatePolicy() {
            clickLoginButton(self.idButton)
        }
    }
    
    @IBAction func clickLoginButton(_ sender: UIButton) {
        biometricIDAuth.authenticateUser { [weak self] message in
            if let message = message {
                // if an error occurred, show an alert indicating it
                let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertView.addAction(okAction)
                self?.present(alertView, animated: true)
            } else {
                self?.performSegue(withIdentifier: SegueIdentifiers.mainView, sender: nil)
            }
        }
    }
}
