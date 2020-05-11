//
//	FirebaseImageService.swift
// 	RecycleProject
//

import UIKit
import Firebase

class FirebaseService {
    
    static func downloadImage (urlString: String, completionHandler: @escaping(_ imageData: Data)->()) {
        
        let maxSize: Int64 = 1 * 1024 * 1024
        
        DispatchQueue.global().async {
            Storage.storage().reference(forURL: urlString).getData(maxSize: maxSize) { (data, error) in
                guard let imageData = data,
                    error == nil else {
                        print(error!.localizedDescription)
                        return
                }
                completionHandler(imageData)
            }
        }
    }
}
