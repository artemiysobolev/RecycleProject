//
//	NameViewController.swift
// 	RecycleProject
//

import UIKit

class FirstUsernameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let username = nameTextField.text, username != "" else { return }
        
        UserDefaults.standard.setUsername(value: username)
    }
    
}
