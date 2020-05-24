//
//	CLLocationCoordinate2D+Extension.swift
// 	RecycleProject
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine((latitude.hashValue&*397) &+ longitude.hashValue)
    }

}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
