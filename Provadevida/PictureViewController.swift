import UIKit
import Foundation
import Alamofire
import CFAlertViewController
import PKHUD
import SwiftyJSON

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let URL: String = "http://192.168.0.79:3000/usuario/"
    let URL2: String = "/validar"
    let picker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {

        super.viewDidLoad()
        picker.delegate = self
        
        DispatchQueue.main.async {
            let alert = CFAlertViewController(title: "Atenção \(AppDelegate.userName!)", message: "Neste passo iremos tirar uma foto que será utilizada para comprovação de vida através do reconhecimento das fotos do seu cadastro.", textAlignment: .justified, preferredStyle: .notification, didDismissAlertHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = chosenImage
            dismiss(animated:true, completion: nil)
            
            let newImage: UIImage = UIImage(cgImage: chosenImage.cgImage!, scale: 0.1, orientation: chosenImage.imageOrientation)
            let data: NSData = UIImageJPEGRepresentation(newImage, 0.9)! as NSData
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
                    if let temp = response.result.value {

                        let json: JSON = JSON(temp)

                        var codigo: Int?
                        if let cod = json["validation_status"].int {
                            codigo = cod
                        } else if let cod = json["erros"][0]["validation_status"].int {
                            codigo = cod
                        } else {
                            return
                        }

                        PKHUD.sharedHUD.hide(afterDelay: 0)
                        if codigo == 0 {
                            let alertController = CFAlertViewController(title: "Sucesso", message: "Você foi reconhecido, vamos ao próximo passo.", textAlignment: .justified, preferredStyle: .notification, didDismissAlertHandler: nil)
                            self.present(alertController, animated: true, completion: nil)

                            let when = DispatchTime.now() + 2
                            DispatchQueue.main.asyncAfter(deadline: when) {
                                self.performSegue(withIdentifier: "video", sender: self)
                            }
                        } else  if codigo == -1 {
                            let alertController = CFAlertViewController(title: "Error", message: "Nenhum rosto foi reconhecido, tente outra foto.", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
                            self.present(alertController, animated: true, completion: nil)
                        } else if codigo == 1 {
                            let alertController = CFAlertViewController(title: "Error", message: "A qualidade da foto não está adequada, tente outra foto.", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
                            self.present(alertController, animated: true, completion: nil)
                        } else if codigo == 2 {
                            let alertController = CFAlertViewController(title: "Error", message: "Seu rosto não é compatível com os dados contidos no seu cadastro.", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    PKHUD.sharedHUD.hide(afterDelay: 0)
                    let alertController = CFAlertViewController(title: "Error", message: "Erro de comunicação com o servidor.", textAlignment: .justified, preferredStyle: .notification, didDismissAlertHandler: nil)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        } else {
            PKHUD.sharedHUD.hide(afterDelay: 0)
            let alertController = CFAlertViewController(title: "Atenção", message: "Antes de enviar, você tem que tirar uma foto primeiro", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
