import UIKit
import Alamofire
import SwiftyJSON
import PKHUD
import CFAlertViewController

class LoginViewController: UIViewController, UITextFieldDelegate {

    let URL: String = "http://192.168.0.39:3000/login/"

    @IBOutlet weak var nb: UITextField!
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var dn: UITextField!
    @IBOutlet weak var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nb.delegate = self
        nb.keyboardType = UIKeyboardType.numberPad
        addDoneButtonOnNumpad(nb)
        cpf.delegate = self
        cpf.keyboardType = UIKeyboardType.numberPad
        addDoneButtonOnNumpad(cpf)
        dn.delegate = self
        dn.keyboardType = UIKeyboardType.numberPad
        addDoneButtonOnNumpad(dn)
    }

    func addDoneButtonOnNumpad(_ textField: UITextField) {
        let keypadToolbar: UIToolbar = UIToolbar()
        keypadToolbar.items=[
            UIBarButtonItem(title: "Pronto", style: UIBarButtonItemStyle.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        textField.inputAccessoryView = keypadToolbar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder();
        animateViewMoving(up: true, moveValue: 100)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func login(_ sender: Any) {

        let parameters: Parameters = [
            "nm_beneficio": nb.text!,
            "cpf": cpf.text!,
            "dt_nascimento": dn.text!
        ]

        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.contentView = PKHUDProgressView()

        Alamofire.request(URL, method: .post, parameters: parameters).responseJSON(completionHandler: { response in
            if response.result.isSuccess {
                if let temp = response.result.value {

                    let json: JSON = JSON(temp)
                    AppDelegate.user = "\(json["cpf"])"
                    AppDelegate.userName = "\(json["nome"])"

                    if let _ = json["cpf"].int {
                        PKHUD.sharedHUD.hide(afterDelay: 0)
                        self.performSegue(withIdentifier: "valido", sender: nil)
                    } else {
                        PKHUD.sharedHUD.hide(afterDelay: 0)
                        let alertController = CFAlertViewController(title: "Error", message: "Não foi possível encontrar beneficiário válido para os dados informados.", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                PKHUD.sharedHUD.hide(afterDelay: 0)
                let alertController = CFAlertViewController(title: "Error", message: "Não foi possível encontrar beneficiário válido para os dados informados.", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
