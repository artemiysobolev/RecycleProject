//
//	FirstLaunchViewController.swift
// 	RecycleProject
//

import UIKit

class FirstPresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        guard InternetConnectionService.isConnectedToNetwork() else {
            showAlert()
            return
        }
        
        FirebaseService.getData(collectionPath: "Publishers") { (data: [Publisher]) in
            UserDefaults.standard.setFavoritePublishers(value: data)
        }
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Нет соединения с интернетом", message: "Подключись к сети, чтобы продолжить", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        okAction.setValue(UIColor(named: "CustomTabBarTintColor"), forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
