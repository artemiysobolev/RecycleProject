//
//    Region.swift
//     RecycleProject
//

import Foundation
import Firebase

struct Region: Codable, genericFirebaseDataProtocol {
    let code: String
    let name: String
    let area: Int
    
    init?(documentSnapshot: QueryDocumentSnapshot) {
        guard let name = documentSnapshot["name"] as? String,
            let area = documentSnapshot["area"] as? Int else {
                return nil
        }
        
        self.code = documentSnapshot.documentID
        self.name = name
        self.area = area
    }

}
