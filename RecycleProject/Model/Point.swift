//
//    Point.swift
//     RecycleProject
//

import UIKit
import CoreLocation
import Firebase

enum Rating: String{
    case untrusted = "Низкий уровень доверия"
    case undefined = "Нет точной информации"
    case trusted = "Проверенный подрядчик"
}

struct Point: genericFirebaseDataProtocol {
    let location: CLLocationCoordinate2D
    let name: String
    let comment: String
    let imageUrlString: String
    let schedule: String
    let lastUpdate: Date
    let recycleCodes: [Int]
    let rating: Rating
    
    init?(documentSnapshot: QueryDocumentSnapshot) {
        guard let name = documentSnapshot["name"] as? String,
            let comment = documentSnapshot["comment"] as? String,
            let imageUrlString = documentSnapshot["imageUrl"] as? String,
            let schedule = documentSnapshot["schedule"] as? String,
            let lastUpdate = (documentSnapshot["lastUpdate"] as? Timestamp)?.dateValue(),
            let ratingInt = documentSnapshot["rating"] as? Int,
            let recycleCodes = documentSnapshot["materials"] as? [Int],
            let locationGeopoint = documentSnapshot["location"] as? GeoPoint else {
                return nil
        }
        
        self.name = name
        self.comment = comment
        self.imageUrlString = imageUrlString
        self.schedule = schedule
        self.lastUpdate = lastUpdate
        self.recycleCodes = recycleCodes
        
        self.location = CLLocationCoordinate2D(latitude: locationGeopoint.latitude,
                                               longitude: locationGeopoint.longitude)
        
        switch ratingInt {
        case 1:
            self.rating = .untrusted
        case 3:
            self.rating = .trusted
        default:
            self.rating = .undefined
        }
    }
}
