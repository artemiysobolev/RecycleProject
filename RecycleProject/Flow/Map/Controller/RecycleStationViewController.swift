//
//	RecycleStationViewControllwe.swift
// 	RecycleProject
//

import UIKit

class RecycleStationViewController: UIViewController {
    @IBOutlet weak var stationImage: UIImageViewFromFirebase!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var recycleCodesCollectionView: UICollectionView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(with recycleStation: RecycleStation) {
        stationImage.loadImageUsingUrlString(urlString: recycleStation.imageUrlString)
    }
    @IBAction func createRouteButtonTapped(_ sender: UIButton) {
    }
    @IBAction func problemReportButtonTapped(_ sender: Any) {
    }
    
}
