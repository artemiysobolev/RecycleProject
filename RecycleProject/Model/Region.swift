//
//	Region.swift
// 	RecycleProject
//

import Foundation
import Firebase

struct Region: Codable {
    let code: Int
    let name: String
    
    init(documentSnapshot: QueryDocumentSnapshot) {
        name = documentSnapshot["name"] as? String ?? ""
        code = documentSnapshot["code"] as? Int ?? 0
    }
    
    init(name: String, code: Int) {
        self.name = name
        self.code = code
    }
}
