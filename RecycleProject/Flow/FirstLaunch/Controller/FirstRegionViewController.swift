//
//	CityViewController.swift
// 	RecycleProject
//

import UIKit

class FirstRegionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var regionPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var regions: [Region] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regionPickerView.alpha = 0
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        doneButton.isEnabled = false
        
        FirebaseService.getData(collectionPath: "Regions") { [weak self]  (data: [Region]) in
            guard let self = self else { return }
            self.regions = data
            self.regionPickerView.reloadAllComponents()
            self.activityIndicator.stopAnimating()
            self.regionPickerView.alpha = 1
            self.doneButton.isEnabled = true
        }
        
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        CoreDataService.shared.getDataFromFile()
        UserDefaults.standard.setLaunchedBefore(value: true)
        let region = regions[regionPickerView.selectedRow(inComponent: 0)]
        UserDefaults.standard.setRegion(value: region)
            
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
        return regions[row].name
    }
}
