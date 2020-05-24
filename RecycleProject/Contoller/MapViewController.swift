//
//    MapViewController.swift
//     RecycleProject
//

import UIKit
import YandexMapKit
import CoreLocation

class MapViewController: UIViewController, YMKUserLocationObjectListener, YMKMapObjectTapListener {
    
    @IBOutlet weak var mapView: YMKMapView!
    let mapkit = YMKMapKit.sharedInstance()
    let scale = UIScreen.main.scale
    let locationManager = CLLocationManager()
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
    
    private func addStationsOnMap() {
        mapObjects.clear()
        for station in stations {
            let pointCoordinate = YMKPoint(latitude: station.value.location.latitude,
                                           longitude: station.value.location.longitude)
            mapObjects
                .addPlacemark(with: pointCoordinate, image: UIImage(named: "userLocation")!)
                .addTapListener(with: placemarkTapListener)
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
    
    //MARK: - YMKMapKit listeners methods
    
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named: "userLocation")!)
        let pinPlacemark = view.pin
        pinPlacemark.setIconWith(UIImage(named: "userLocation")!)
        view.accuracyCircle.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false }
        let geometry = placemark.geometry
        let currentCoordinate = CLLocationCoordinate2D(latitude: geometry.latitude, longitude: geometry.longitude)
        let currentStation = stations[currentCoordinate]
        print(currentStation?.name)
        
        return true
    }
}
