//
//	NameViewController.swift
// 	RecycleProject
//

import UIKit

class FirstUsernameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let username = nameTextField.text,
            !username.isEmptyOrWhitespace() {
            UserDefaults.standard.setUsername(value: username.trimmingCharacters(in: .whitespacesAndNewlines))
            performSegue(withIdentifier: "toRegionSegue", sender: self)
        }
        
    }
    
}

extension FirstUsernameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
