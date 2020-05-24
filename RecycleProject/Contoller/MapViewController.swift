//
//    MapViewController.swift
//     RecycleProject
//

import UIKit
import YandexMapKit
import CoreLocation

class MapViewController: UIViewController, YMKUserLocationObjectListener {
    
    @IBOutlet weak var mapView: YMKMapView!
    let mapkit = YMKMapKit.sharedInstance()
    let scale = UIScreen.main.scale
    let locationManager = CLLocationManager()
    var userLocation: YMKUserLocationLayer!
    var mapObjects: YMKMapObjectCollection {
        return mapView.mapWindow.map.mapObjects
    }
    var points: [Point] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapWindow.map.isRotateGesturesEnabled = false

        loadPointsFromServer()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        configureUserLocation()
        setupMapFocus()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private func loadPointsFromServer() {
        guard let regionCode = UserDefaults.standard.getRegion()?.code else { return }
        FirebaseService.getData(collectionPath: "Regions/\(regionCode)/Points") { (data: [Point]) in
            self.points = data
            self.addPointsToMap()
        }
    }
    
    private func addPointsToMap() {
        mapObjects.clear()
        for point in points {
            let pointCoordinate = YMKPoint(latitude: point.location.latitude, longitude: point.location.longitude)
            let placemark = mapObjects.addPlacemark(with: pointCoordinate)
            placemark.setIconWith(UIImage(named: "userLocation")!)
        }
    }
    
    private func configureUserLocation() {
        userLocation = mapkit.createUserLocationLayer(with: mapView.mapWindow)
        userLocation.setVisibleWithOn(true)
        userLocation.setObjectListenerWith(self)
    }
    
    func setupMapFocus() {
        var focusPoint = YMKPoint()
        if let userCoordinate = locationManager.location?.coordinate {
            focusPoint = YMKPoint(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        } else {
            focusPoint = YMKPoint(latitude: 59.950749, longitude: 30.316751) // city coordinates
        }
        mapView.mapWindow.map.move(with: YMKCameraPosition(target: focusPoint, zoom: 12, azimuth: 0, tilt: 0))
    }
    
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named: "userLocation")!)
        let pinPlacemark = view.pin
        pinPlacemark.setIconWith(UIImage(named: "userLocation")!)
        view.accuracyCircle.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}
