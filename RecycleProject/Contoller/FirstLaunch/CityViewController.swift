//
//	CityViewController.swift
// 	RecycleProject
//

import UIKit

class CityViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var cityPickerView: UIPickerView!
    let regions = ["Санкт-Петербург", "Москва", "Хантымансийский автономный округ", "Череповец"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.setLaunchedBefore(value: true)
        UserDefaults.standard.setRegion(value: regions[cityPickerView.selectedRow(inComponent: 0)])

        
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = sb.instantiateInitialViewController() as! UITabBarController
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: false)
            
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        regions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard regions.indices.contains(row) else { return nil }
        return regions[row]
    }
}
