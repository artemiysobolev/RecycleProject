//
//	NewsViewController.swift
// 	RecycleProject
//

import UIKit
import Firebase

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let db = Firestore.firestore()
    private var publishers: [String] = []
    var news: [NewsItem] = []
    var currentNewsItem: NewsItem?
    


    override func viewDidLoad() {
        UserDefaults.standard.setFavoritePublishers(value: ["99recycle", "RecycleMag","РазДельный Сбор"])
        publishers = UserDefaults.standard.getFavoritePublishers()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        FirebaseService.getData(collectionPath: "News") { [weak self] (data: [NewsItem]) in
            guard let self = self else { return }
            self.news = data
            self.tableView.reloadData()
        }
    
//        db.collection("News").whereField("publisher", in: publishers).getDocuments { (snapshot, error) in
//            guard let snapshot = snapshot,
//                error == nil else {
//                    print(error!.localizedDescription)
//                    return
//            }
//
//            var _news: [NewsItem] = []
//            for document in snapshot.documents {
//                if let newsItem = NewsItem(documentSnapshot: document) {
//                    _news.append(newsItem)
//                }
//            }
//            self.news = _news
//            self.tableView.reloadData()
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "NewsItemSegue",
            let newsItemVC = segue.destination as? NewsItemViewController  else { return }
        newsItemVC.newsItem = currentNewsItem
    }
}
