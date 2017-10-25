import UIKit
import Foundation
import AVFoundation
import Alamofire
import CFAlertViewController
import PKHUD
import MobileCoreServices

class VideoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let URL: String = "http://192.168.0.78:3000/usuario/"
    let URL2: String = "/video"
    let picker = UIImagePickerController()
    var videoBase64: String?
    
    @IBOutlet weak var videoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let alertController = CFAlertViewController(title: "Atenção", message: "Neste passo iremos gravar um video com uma frase.", textAlignment: .justified, preferredStyle: .notification, didDismissAlertHandler: nil)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoURL = info[UIImagePickerControllerMediaURL] as! URL
        dismiss(animated:true, completion: nil)
        
        if let fileURL: NSURL = info[UIImagePickerControllerMediaURL] as! NSURL {
            if let data = NSData.init(contentsOf: fileURL as URL) {
                videoBase64 = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
                print(videoBase64)
            }
        }

        //let data: NSData = UIImageJPEGRepresentation(chosenImage, 0.9)! as NSData
        //videoBase64 = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        videoView.image = UIImage(named: "photo")
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
                    if let json = response.result.value {
                        print(json)
                    }
                } else {
                    print(response.result)
                }
                
                PKHUD.sharedHUD.hide(afterDelay: 2.0)
            })
        } else {
            let alertController = CFAlertViewController(title: "Atenção", message: "Antes de enviar, você tem que tirar um video primeiro", textAlignment: .justified, preferredStyle: .alert, didDismissAlertHandler: nil)
            present(alertController, animated: true, completion: nil)
        }
    }
}

