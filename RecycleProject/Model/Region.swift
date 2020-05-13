//
//	Region.swift
// 	RecycleProject
//

import Foundation
import Firebase

struct Region: Codable, genericFirebaseDataProtocol {
    let code: Int
    let name: String
    
    init?(documentSnapshot: QueryDocumentSnapshot) {
        guard let code = documentSnapshot["code"] as? Int,
            let name = documentSnapshot["name"] as? String else {
                return nil
        }
        self.code = code
        self.name = name
    }

}
