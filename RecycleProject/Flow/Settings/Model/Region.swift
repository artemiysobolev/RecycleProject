//
//    Region.swift
//     RecycleProject
//

import Foundation
import Firebase

struct Region: Codable, genericFirebaseDataProtocol {
    let code: String
    let name: String
    
    init?(documentSnapshot: QueryDocumentSnapshot) {
        guard let name = documentSnapshot["name"] as? String else {
                return nil
        }
        
        self.code = documentSnapshot.documentID
        self.name = name
    }

}
