//
//	RecycleStationViewControllwe.swift
// 	RecycleProject
//

import UIKit
import CoreLocation

class RecycleStationViewController: UIViewController {
    @IBOutlet weak var stationImage: UIImageViewFromFirebase!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var recycleCodesCollectionView: UICollectionView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentStackView: UIStackView!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    private let geocoder = CLGeocoder()
    private let dateFormatter = DateFormatter()
    var currentRecycleStation: RecycleStation!
    var currentStationAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd.MM.yyyy"
    }
    
    func configureView(with recycleStation: RecycleStation) {
        currentRecycleStation = recycleStation
        stationImage.loadImageUsingUrlString(urlString: recycleStation.imageUrlString)
        nameLabel.text = recycleStation.name
        scheduleLabel.text = recycleStation.schedule
        setupRatingColor(with: recycleStation.rating)
        ratingLabel.text = recycleStation.rating.rawValue
        if recycleStation.comment == nil {
            commentStackView.isHidden = true
        } else {
            commentLabel.text = recycleStation.comment
        }
        lastUpdateLabel.text = dateFormatter.string(from: recycleStation.lastUpdate)
        getAddress(from: recycleStation.location) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .some(let address):
                self.addressLabel.text = address
                self.currentStationAddress = address
            case .none:
                self.addressLabel.text = "Адрес не определен"
            }
        }
        recycleCodesCollectionView.reloadData()

    }
    @IBAction func createRouteButtonTapped(_ sender: UIButton) {
        guard let location = currentRecycleStation?.location else { return }
        createRoute(to: location, named: currentStationAddress)
    }
    
    @IBAction func problemReportLabelButtonTapped(_ sender: Any) {
        sendEmail()
    }
    @IBAction func problemReportButtonTapped(_ sender: Any) {
        sendEmail()
    }
    
    func setupImageView() {
        stationImage.layer.masksToBounds = false
        stationImage.layer.shadowColor = UIColor.black.cgColor
        stationImage.layer.shadowOpacity = 1
        stationImage.layer.shadowOffset = CGSize(width: -1, height: 1)
        stationImage.layer.shadowRadius = 1
    }
    
    func setupRatingColor(with rating: Rating) {
        switch rating {
        case .trusted:
            ratingLabel.textColor = UIColor.goodRecycleStatusColor
        case .undefined:
            ratingLabel.textColor = UIColor.normalRecycleStatusColor
        case .untrusted:
            ratingLabel.textColor = UIColor.badRecycleStatusColor
        }
    }
    
    func getAddress(from coordinate: CLLocationCoordinate2D, completion: @escaping(_ address: String?)->()) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(nil)
                    return
                }
                completion(placemarks?[0].name)
            }
        }
    }
    
}
