//
//	Publisher.swift
// 	RecycleProject
//

import UIKit
import Firebase

struct Publisher: genericFirebaseDataProtocol, Codable {
    let id: Int
    let name: String
    
    init?(documentSnapshot: QueryDocumentSnapshot) {
        guard let id = documentSnapshot["id"] as? Int,
            let name = documentSnapshot["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
    }
}
