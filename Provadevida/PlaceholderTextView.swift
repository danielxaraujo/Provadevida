import UIKit
import Foundation

@IBDesignable class PlaceholderTextView: UITextField, UITextViewDelegate
{

    private let placeholderColor: UIColor = UIColor.lightGray
    private var textColorCache: UIColor!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = textColorCache
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" && placeholder != "" {
            setPlaceholderText()
        }
    }
    
    func setPlaceholderText() {
        if placeholder != "" {
            if textColorCache == nil { textColorCache = self.textColor }
            self.textColor = placeholderColor
            self.text = placeholder
        }
    }
}
