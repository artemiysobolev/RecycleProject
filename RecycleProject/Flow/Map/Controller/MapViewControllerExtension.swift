//
//    MapViewControllerExtension.swift
//     RecycleProject
//

import Foundation
import YandexMapKit
import CoreLocation

//MARK: - Location manager delegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.first != nil else {
            return
        }
        setupMapFocus()
        locationManager.stopUpdatingLocation()
    }
}

//MARK: - Work with Yandex MapKit

extension MapViewController: YMKUserLocationObjectListener, YMKMapObjectTapListener {
    internal func addStationsOnMap() {
        mapObjects.clear()
        for station in stations {
            let pointCoordinate = YMKPoint(latitude: station.value.location.latitude,
                                           longitude: station.value.location.longitude)
            mapObjects
                .addPlacemark(with: pointCoordinate, image: UIImage(named: "userLocation")!)
                .addTapListener(with: placemarkTapListener)
        }
    }
    
    internal func configureUserLocation() {
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
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false }
        let geometry = placemark.geometry
        let currentCoordinate = CLLocationCoordinate2D(latitude: geometry.latitude, longitude: geometry.longitude)
        let currentStation = stations[currentCoordinate]
        print(currentStation?.name)
        
        return true
    }
}
