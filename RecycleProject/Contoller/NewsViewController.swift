//
//	NewsViewController.swift
// 	RecycleProject
//

import UIKit
import Firebase

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let db = Firestore.firestore()
//    private let publishers = ["99recycle", "RecycleMag"]
    var news: [NewsItem] = []
    var currentNewsItem: NewsItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    
        db.collection("News").getDocuments { (snapshot, error) in
//        db.collection("News").whereField("publisher", in: publishers).getDocuments { (snapshot, error) in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "NewsItemSegue",
            let newsItemVC = segue.destination as? NewsItemViewController  else { return }
        newsItemVC.newsItem = currentNewsItem
    }
}
