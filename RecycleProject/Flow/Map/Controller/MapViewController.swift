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
    var userLocation: YMKUserLocationLayer!
    var mapObjects: YMKMapObjectCollection {
        return mapView.mapWindow.map.mapObjects
    }
    var placemarkTapListener: YMKMapObjectTapListener {
        return self
    }
    var stations: [CLLocationCoordinate2D: RecycleStation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        loadPointsFromServer()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        configureUserLocation()
        setupMapFocus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Remove the views managed by the `FloatingPanelController` object from self.view.
        recycleStationVC.removePanelFromParent(animated: true)
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
