//
//	FirebaseImageService.swift
// 	RecycleProject
//

import UIKit
import Firebase

var imageCache = NSCache<NSString, UIImage>()

class FirebaseService {
    
    static func downloadImage (urlString: String, completionHandler: @escaping(_ imageData: UIImage)->()) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completionHandler(cachedImage)
        } else {
            let maxSize: Int64 = 1 * 1024 * 1024
            
            DispatchQueue.global().async {
                Storage.storage().reference(forURL: urlString).getData(maxSize: maxSize) { (data, error) in
                    guard let imageData = data,
                        error == nil else {
                            print(error!.localizedDescription)
                            return
                    }
                    guard let image = UIImage(data: imageData) else { return }
                    imageCache.setObject(image, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
            }
        }
    }
    
    
    static func getRegions (completionHandler: @escaping(_ regions: [Region])->()) {
        DispatchQueue.global().async {
            Firestore.firestore().collection("Regions").getDocuments { (snapshot, error) in
                guard let snapshot = snapshot,
                    error == nil else {
                        print(error!.localizedDescription)
                        return
                }
                
                var regions: [Region] = []
                for document in snapshot.documents {
                    let region = Region(documentSnapshot: document)
                    regions.append(region)
                }
                DispatchQueue.main.async {
                    completionHandler(regions)
                }
            }
        }
    }
}
