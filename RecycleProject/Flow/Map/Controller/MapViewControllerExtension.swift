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
        guard locations.first != nil else {
            return
        }
                
        setupMapFocus()
        locationManager.stopUpdatingLocation()
    }
}
