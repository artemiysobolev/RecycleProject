//
//    MapViewController.swift
//     RecycleProject
//

import UIKit
import YandexMapKit
import CoreLocation
import FloatingPanel

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: YMKMapView!
    let mapkit = YMKMapKit.sharedInstance()
    let scale = UIScreen.main.scale
    let locationManager = CLLocationManager()
    var recycleStationVC: FloatingPanelController!
    var contentVC: RecycleStationViewController!
    var userLocation: YMKUserLocationLayer!
    var collection: YMKClusterizedPlacemarkCollection!
    var placemarkTapListener: YMKMapObjectTapListener {
        return self
    }
    var stations: [CLLocationCoordinate2D: RecycleStation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        configureFloatingPanel()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        configureUserLocation()
        collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        loadPointsFromServer()
        setupMapFocus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        recycleStationVC?.removePanelFromParent(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private func loadPointsFromServer() {
        guard let regionCode = UserDefaults.standard.getRegion()?.code else { return }
        FirebaseService.getData(collectionPath: "Regions/\(regionCode)/Points") { (data: [RecycleStation]) in
            for station in data {
                self.stations[station.location] = station
            }
            self.addStationsOnMap()
        }
    }
}
