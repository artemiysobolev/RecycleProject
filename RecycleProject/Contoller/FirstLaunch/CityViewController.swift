//
//	CityViewController.swift
// 	RecycleProject
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var cityPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.setLaunchedBefore(value: true)
    }
    
}
