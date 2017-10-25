import UIKit
import Foundation
import Alamofire
import CFAlertViewController
import PKHUD

class VideoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let URL: String = "http://192.168.0.39:3000/usuario/96602210378/imagem"
    let picker = UIImagePickerController()
    var videoBase64: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let alertController = CFAlertViewController(title: "Atenção", message: "Neste passo iremos gravar um video com uma frase.", textAlignment: .justified, preferredStyle: .notification, didDismissAlertHandler: nil)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //imageView.contentMode = .scaleAspectFill
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
        
        //let smallImage: UIImage = UIImage(cgImage: chosenImage.cgImage!, scale: 0., orientation: chosenImage.imageOrientation);
        
        let data: NSData = UIImageJPEGRepresentation(chosenImage, 0.9)! as NSData
        videoBase64 = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageView.image = UIImage(named: "photo")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .video
            picker.modalPresentationStyle = .fullScreen
            picker.videoQuality = UIImagePickerControllerQualityType.typeLow
            picker.videoMaximumDuration = 10.0
            present(picker,animated: true,completion: nil)
        }
    }
    
    @IBAction func sendPhoto(_ sender: UIButton) {
        if let newImagem64 = videoBase64 {
            let parameters: Parameters = [
                "imagem": newImagem64
            ]
            
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            
            Alamofire.request(URL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
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

