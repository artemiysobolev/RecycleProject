//
//	KeyboardService.swift
// 	RecycleProject
//

import UIKit


class KeyboardService {
    
    static let shared = KeyboardService()
    
    private init () {}
    
    @objc func keyboardWillChange (notification: Notification, view: UIView) {
        guard let keyboardRect = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height / 2
        } else {
            view.frame.origin.y = 0
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func addKeyboardHideGesture(view: UIView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                  action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(view: UIView) {
        view.endEditing(true)
    }
    
}
