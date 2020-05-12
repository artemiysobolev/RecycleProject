//
//	Publisher.swift
// 	RecycleProject
//

import UIKit
import Firebase

struct Publisher {
    let id: Int
    let name: String
    
    init?(documentSnapshot: DocumentSnapshot) {
        guard let id = documentSnapshot["id"] as? Int,
            let name = documentSnapshot["name"] as? String else {
                print("Some problem with init this document: \(documentSnapshot)")
                return nil
        }
        self.id = id
        self.name = name
    }
}
