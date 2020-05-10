//
//	NewsViewController.swift
// 	RecycleProject
//

import UIKit
import Firebase


class NewsViewController: UIViewController {
    
    let db = Firestore.firestore()
    let publishers = ["99recycle"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        db.collection("News").whereField("Publisher", in: publishers).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot,
                error == nil else {
                    print(error!.localizedDescription)
                    return
            }
            
            for document in snapshot.documents {
                print(document.data())
            }
        }
        
        print("NewsViewController did load")
    }
}
