import UIKit
import Foundation
import Alamofire
import CFAlertViewController
import PKHUD    

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let URL: String = "http://192.168.0.78:3000/usuario/"
    let URL2: String = "/validar"
    let picker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {

        super.viewDidLoad()
        picker.delegate = self

        let alertController = CFAlertViewController(title: "Atenção", message: "Neste passo iremos tirar uma foto que será utilizada para comprovação de vida através do reconhecimento das fotos do seu cadastro.", textAlignment: .justified, preferredStyle: .notification, didDismissAlertHandler: nil)
        present(alertController, animated: true, completion: nil)
    }

    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = chosenImage
            dismiss(animated:true, completion: nil)
            
            let data: NSData = UIImageJPEGRepresentation(chosenImage, 0.9)! as NSData
            AppDelegate.image64 = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageView.image = UIImage(named: "photo")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.videoQuality = UIImagePickerControllerQualityType.typeLow
            present(picker,animated: true,completion: nil)
        }
    }

    @IBAction func sendPhoto(_ sender: UIButton) {
        if let newImagem64 = AppDelegate.image64 {
            let parameters: Parameters = [
                "imagem": newImagem64
            ]

            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.contentView = PKHUDProgressView()

            let newURL: String = URL + AppDelegate.user! + URL2
            Alamofire.request(newURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
                if response.result.isSuccess {
                    if let json = response.result.value {
                        print(json)
                    }
                } else {
                    print(response.result)
                }

                PKHUD.sharedHUD.hide(afterDelay: 2.0)
            })
        } else {
            let alertController = CFAlertViewController(title: "Atenção", message: "Antes de enviar, você tem que tirar uma foto primeiro", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
            present(alertController, animated: true, completion: nil)
        }
    }
}
