//
//	MaterialViewController.swift
// 	RecycleProject
//

import UIKit

class MaterialViewController: UIViewController {
    @IBOutlet var materialView: MaterialView!
    var material: Material!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        materialView.setupViews(with: material)
    }
}
