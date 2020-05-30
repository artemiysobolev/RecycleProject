//
//	RecycleStationViewControllwe.swift
// 	RecycleProject
//

import UIKit

class RecycleStationViewController: UIViewController {
    @IBOutlet weak var stationImage: UIImageViewFromFirebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(with recycleStation: RecycleStation) {
        stationImage.loadImageUsingUrlString(urlString: recycleStation.imageUrlString)
    }
}
