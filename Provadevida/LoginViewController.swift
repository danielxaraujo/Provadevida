import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    let URL: String = "http://192.168.0.142:3000/login/"

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

        //Alamofire.request(URL, method: .post, parameters: parameters).responseJSON(completionHandler: { response in
            //if response.result.isSuccess {
                //if let json = response.result.value {
                    self.performSegue(withIdentifier: "valido", sender: self/*json*/)
                //}
            //}
        //})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
