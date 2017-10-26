import UIKit
import Foundation
import AVFoundation
import Alamofire
import CFAlertViewController
import PKHUD
import MobileCoreServices
import AVKit
import SwiftyJSON

class VideoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let URL: String = "http://192.168.0.79:3000/usuario/"
    let URL2: String = "/video"
    let picker = UIImagePickerController()
    var videoBase64: String?
    var videoURL: URL?

    var player = AVPlayer()
    var playerController = AVPlayerViewController()

    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        DispatchQueue.main.async {
            let alert = CFAlertViewController(title: "Atenção \(AppDelegate.userName!)", message: "Estamos quase acabando, neste passo iremos gravar um vídeo que será utilizada para comprovar que você é a mesma da foto.", textAlignment: .justified, preferredStyle: .notification, didDismissAlertHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated:true, completion: nil)
        if let fileURL: NSURL = info[UIImagePickerControllerMediaURL] as? NSURL {
            self.videoURL = fileURL.absoluteURL
            playVideo()
            if let data = NSData.init(contentsOf: fileURL as URL) {
                videoBase64 = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func encodeVideo(videoURL: URL) -> URL? {

        let avAsset = AVURLAsset(url: videoURL)
        let startDate = Date()
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        
        let docDir = NSSearchPathForDirectoriesInDomains(.autosavedInformationDirectory, .userDomainMask, true)[0]
        let myDocPath = NSURL(fileURLWithPath: docDir).appendingPathComponent("temp.mp4")?.absoluteString
        let docDir2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL

        let filePath = docDir2.appendingPathComponent("video.mp4")
        deleteFile(filePath!)

        if FileManager.default.fileExists(atPath: myDocPath!){
            do{
                try FileManager.default.removeItem(atPath: myDocPath!)
            }catch let error{
                print(error)
            }
        }
        
        exportSession?.outputURL = filePath
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.shouldOptimizeForNetworkUse = true
        
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRange(start: start, duration: avAsset.duration)
        exportSession?.timeRange = range
        
        exportSession!.exportAsynchronously{() -> Void in
            switch exportSession!.status{
            case .failed:
                print("\(exportSession!.error!)")
            case .cancelled:
                print("Export cancelled")
            case .completed:
                let endDate = Date()
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful")
                break
            default:
                break
            }
        }
        return exportSession?.outputURL
    }

    func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else{
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
    
    @IBAction func shootVideo(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.cameraDevice = .rear
            //picker.cameraCaptureMode = .video
            picker.modalPresentationStyle = .fullScreen
            picker.videoMaximumDuration = 10.0
            picker.mediaTypes = [kUTTypeMovie as String!]
            present(picker,animated: true,completion: nil)
        }
    }
    
    @IBAction func sendVideo(_ sender: UIButton) {
        if let newVideoBase64 = videoBase64 {
            let parameters: Parameters = [
                "video": newVideoBase64
            ]
            
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            
            let newURL: String = URL + AppDelegate.user! + URL2
            Alamofire.request(newURL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
                if response.result.isSuccess {
                    if let json: JSON = JSON(response.result.value as Any?) {
                        var codigo: Int?
                        if let cod = json["validation_status"].int {
                            codigo = cod
                            if (codigo == 0) {
                                PKHUD.sharedHUD.hide(afterDelay: 0)
                                let alertController = CFAlertViewController(title: "Sucesso", message: "Seu vídeo foi enviado com sucesso.", textAlignment: .justified, preferredStyle: .notification, didDismissAlertHandler: nil)
                                self.present(alertController, animated: true, completion: nil)
                                
                                let when = DispatchTime.now() + 2
                                DispatchQueue.main.asyncAfter(deadline: when) {
                                    self.performSegue(withIdentifier: "posvideo", sender: self)
                                }
                            }
                        }
                    }
                } else {
                    print(response.result)
                }
            })
        } else {
            PKHUD.sharedHUD.hide(afterDelay: 0)
            let alertController = CFAlertViewController(title: "Atenção", message: "Antes de enviar, você tem que tirar um video primeiro", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
            present(alertController, animated: true, completion: nil)
        }
    }

    func playVideo() {
        player = AVPlayer(url: self.videoURL!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChildViewController(playerController)
        
        // Add your view Frame
        playerController.view.frame = videoView.frame
        
        // Add sub view in your view
        videoView.addSubview(playerController.view)
        
        player.play()
    }

    func stopVideo() {
        player.pause()
    }
}

