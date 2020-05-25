//
//	RecycleStationViewControllwe.swift
// 	RecycleProject
//

import UIKit

class RecycleStationViewController: UIViewController {
    
    @IBOutlet weak var stationImage: UIImageViewFromFirebase!
    var recycleStation: RecycleStation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationImage.loadImageUsingUrlString(urlString: recycleStation.imageUrlString)
    }
}
