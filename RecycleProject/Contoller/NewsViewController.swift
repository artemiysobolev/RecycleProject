//
//	NewsViewController.swift
// 	RecycleProject
//

import UIKit

class NewsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard UserDefaults.standard.isLaunchedBefore() else {
            DispatchQueue.main.async {
                let sb = UIStoryboard(name: "FirstLaunch", bundle: nil)
                let launchVC = sb.instantiateViewController(withIdentifier: "FirstLaunchViewController") as! FirstLaunchViewController
                launchVC.modalPresentationStyle = .fullScreen
                self.present(launchVC, animated: false)
            }
            return
        }
        print("NewsViewController did load")
    }
    
}
