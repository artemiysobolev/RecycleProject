//
//	NewsItem.swift
// 	RecycleProject
//

import Foundation
import Firebase

struct NewsItem {
    let title: String
    let publisher: String
    let annotation: String
    let body: String
    let imageUrlString: String
    let date: Date
    
    init(documentSnapshot: QueryDocumentSnapshot) {
        title = documentSnapshot["title"] as? String ?? ""
        publisher = documentSnapshot["publisher"] as? String ?? ""
        annotation = documentSnapshot["annotation"] as? String ?? ""
        body = documentSnapshot["body"] as? String ?? ""
        imageUrlString = documentSnapshot["imageUrlString"] as? String ?? ""
        date = (documentSnapshot["timestamp"] as? Timestamp)?.dateValue() ?? Date()
    }
}
