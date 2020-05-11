//
//	NewsViewController.swift
// 	RecycleProject
//

import UIKit
import Firebase


class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let publishers = ["99recycle", "RecycleMag"]
    var news: [NewsItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    
        db.collection("News").whereField("publisher", in: publishers).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot,
                error == nil else {
                    print(error!.localizedDescription)
                    return
            }
            
            var _news: [NewsItem] = []
            for document in snapshot.documents { //don't need weak self (firebase documentation)
                let newsItem = NewsItem(documentSnapshot: document)
                _news.append(newsItem)
            }
            self.news = _news
            self.tableView.reloadData()
            
            for i in self.news {
                print(i)
            }
            
        }
        
        print("NewsViewController did load")
    }
}
