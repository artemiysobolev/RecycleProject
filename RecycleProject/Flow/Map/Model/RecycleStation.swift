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

struct RecycleStation: genericFirebaseDataProtocol {
    let location: CLLocationCoordinate2D
    let name: String
    let comment: String?
    let imageUrlString: String
    let schedule: String
    let lastUpdate: Date
    let recycleCodes: [Int]
    let rating: Rating
    let colors: [UIColor]
    
    init?(documentSnapshot: QueryDocumentSnapshot) {
        guard let name = documentSnapshot["name"] as? String,
            let imageUrlString = documentSnapshot["imageUrl"] as? String,
            let schedule = documentSnapshot["schedule"] as? String,
            let lastUpdate = (documentSnapshot["lastUpdate"] as? Timestamp)?.dateValue(),
            let ratingInt = documentSnapshot["rating"] as? Int,
            let recycleCodes = documentSnapshot["materials"] as? [Int],
            let locationGeopoint = documentSnapshot["location"] as? GeoPoint else {
                return nil
        }
        
        self.comment = documentSnapshot["comment"] as? String
        
        self.name = name
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
        
        
        var tempColors: [UIColor] = []
        _ = recycleCodes.map { code -> () in
            switch code {
            case 0..<10:
                if !tempColors.contains(UIColor.plasticColor) { tempColors.append(UIColor.plasticColor) }
            case 20..<30:
                if !tempColors.contains(UIColor.wastepaperColor) { tempColors.append(UIColor.wastepaperColor) }
            case 40..<50:
                if !tempColors.contains(UIColor.metalColor) { tempColors.append(UIColor.metalColor) }
            case 70..<80:
                if !tempColors.contains(UIColor.glassColor) { tempColors.append(UIColor.glassColor) }
            case 80..<90:
                if !tempColors.contains(UIColor.compositeColor) { tempColors.append(UIColor.compositeColor) }
            case 100...200:
                if !tempColors.contains(UIColor.otherColor) { tempColors.append(UIColor.otherColor) }
            default: break
            }
        }
        self.colors = tempColors
    }
}
