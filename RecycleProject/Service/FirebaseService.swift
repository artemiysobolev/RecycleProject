//
//	FirebaseImageService.swift
// 	RecycleProject
//

import UIKit
import Firebase

protocol genericFirebaseDataProtocol {
    init?(documentSnapshot: QueryDocumentSnapshot)
}

var imageCache = NSCache<NSString, UIImage>()
let maxSize: Int64 = 5 * 1024 * 1024 // 5 MB

class FirebaseService {
    
    static func getRecyclePointsCount(whichAccept recycleCode: Int16, completionHandler: @escaping(_ count: Int?)->()) {
        guard let region = UserDefaults.standard.getRegion()?.code else {
            completionHandler(nil)
            return
        }
        let code = Int(recycleCode)
        Firestore.firestore().collection("Regions/\(region)/Points").whereField("materials", arrayContains: code).getDocuments { (snapshot, error) in
            DispatchQueue.main.async {
                guard let snapshot = snapshot, error == nil else {
                    completionHandler(nil)
                    return
                }
                
                let count = snapshot.documents.count
                completionHandler(count)
            }
        }
    }
    
    static func getSupportingEmail(completionHandler: @escaping(_ email: String?)->()) {
        Firestore.firestore().collection("Support").getDocuments { (snapshot, error) in
            DispatchQueue.main.async {
                guard let snapshot = snapshot, error == nil else {
                    completionHandler(nil)
                    return
                }
                
                guard let data = snapshot.documents.first,
                    let email = data["email"] as? String else {
                        completionHandler(nil)
                        return
                }
                completionHandler(email)
            }
        }
    }
    
    static func getSpecialMaterialName(code: Int, completionHandler: @escaping(_ email: String?)->()) {
        
        Firestore.firestore().collection("SpecialRecycleCodes").whereField("code", isEqualTo: code).getDocuments { (snapshot, error) in
            DispatchQueue.main.async {
                guard let snapshot = snapshot, error == nil else {
                    completionHandler(nil)
                    return
                }
                
                guard let data = snapshot.documents.first,
                    let name = data["name"] as? String else {
                        completionHandler(nil)
                        return
                }
                completionHandler(name)
            }
        }
    }
    
    static func getData<T: genericFirebaseDataProtocol>(collectionPath: String, filterBy: String? = nil, filterArray: [String]? = nil, completionHandler: @escaping(_ data: [T])->()) {
        
        var query: Query
        
        if let filterBy = filterBy, let filterArray = filterArray {
            if filterArray.isEmpty {
                let result: [T] = []
                completionHandler(result)
                return
            }
            query = Firestore.firestore().collection(collectionPath).whereField(filterBy, in: filterArray)
        } else {
            query = Firestore.firestore().collection(collectionPath)
        }
        
        DispatchQueue.global().async {
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot,
                    error == nil else {
                        print(error!.localizedDescription)
                        return
                }
                
                var data: [T] = []
                for document in snapshot.documents {
                    if let dataItem = T(documentSnapshot: document) {
                        data.append(dataItem)
                    } else {
                        print("Some problem with init this document: \(document.documentID)")
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(data)
                }
            }
        }
    }
}

class UIImageViewFromFirebase: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }).resume()
    }
    
}
