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
        annotation = (documentSnapshot["annotation"] as? String ?? "").replacingOccurrences(of: "\\n", with: "\n")
        body = (documentSnapshot["body"] as? String ?? "").replacingOccurrences(of: "\\n", with: "\n")
        imageUrlString = documentSnapshot["imageUrl"] as? String ?? ""
        date = (documentSnapshot["date"] as? Timestamp)?.dateValue() ?? Date(timeIntervalSince1970: 0)
    }
}
