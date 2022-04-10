import UIKit

extension UIViewController {
    
    func alertError(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(alertOk)
        
        present(alertController, animated: true)
    }
}

extension UIViewController: AlertErrorDelegate {
    func presentAlert(reason: AlertsReasons) {
        switch reason {
        case .loginAndPassDoesnotMatch:
            alertError(title: "Login and password doesnot match", message: "try again")
        case .wrongUser:
            alertError(title: "Wrong user", message: "User with that name doesnot exist")
        case .userAlreadyExist:
            alertError(title: "User already exist", message: "Try another name")
        case .defaultsFall:
            alertError(title: "No users found", message: "Connect with developer")
        case .noLogin:
            alertError(title: "Please, enter your login", message: "Login must consist at least 1 character")
        case .noPassword:
            alertError(title: "Please, enter your password", message: "Password must consist at least 1 character")
        case .passwordDoesNotMatch:
            alertError(title: "Password's doesnot match", message: "Check your passwords")
        case .imageLoadFalled:
            alertError(title: "Failed to load image", message: "Please, try again")
        case .noImages:
            alertError(title: "No images to display", message: "Add at least 1 image to your photo library")
        case .noPermission:
            alertError(title: "Please, change the photo-privacy status in settings", message: "Our app needs 1 or more photos from your library")
        }
        
    }
}
