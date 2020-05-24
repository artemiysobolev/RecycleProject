//
//    MapViewControllerExtension.swift
//     RecycleProject
//

import Foundation
import YandexMapKit
import CoreLocation

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        let coordinate = location.coordinate
        
        mapView.mapWindow.map.move(with:
            YMKCameraPosition(target: YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude),
                              zoom: 15, azimuth: 0, tilt: 0))
        
        locationManager.stopUpdatingLocation()
    }
}
