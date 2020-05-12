//
//	NewsItem.swift
// 	RecycleProject
//

import Foundation
import Firebase

struct NewsItem: genericFirebaseDataProtocol {
    let title: String
    let publisher: String
    let annotation: String
    let body: String
    let imageUrlString: String
    let date: Date
    
    init?(documentSnapshot: QueryDocumentSnapshot) {
        guard let title = documentSnapshot["title"] as? String,
            let publisher = documentSnapshot["publisher"] as? String,
            var annotation = documentSnapshot["annotation"] as? String,
            var body = documentSnapshot["body"] as? String,
            let imageUrlString = documentSnapshot["imageUrl"] as? String,
            let date = (documentSnapshot["date"] as? Timestamp)?.dateValue() else {
                return nil
        }
        
        body = body.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "\t")
        annotation = annotation.replacingOccurrences(of: "\\n", with: "\n")

        self.title = title
        self.publisher = publisher
        self.annotation = annotation
        self.body = body
        self.imageUrlString = imageUrlString
        self.date = date
    }
}
