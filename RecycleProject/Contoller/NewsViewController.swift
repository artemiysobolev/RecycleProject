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
        super.viewDidLoad()
        print(UserDefaults.standard.getRegion())
        print(UserDefaults.standard.isLaunchedBefore())
        print(UserDefaults.standard.getFavoritePublishers())
        print(UserDefaults.standard.overridedUserInterfaceStyle)
        print(UserDefaults.standard.isNotificationsEnabled())
        print(UserDefaults.standard.getUsername())

        
        UserDefaults.standard.setFavoritePublishers(value: ["99recycle", "RecycleMag","РазДельный Сбор"])
        publishers = UserDefaults.standard.getFavoritePublishers()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    
        db.collection("News").whereField("publisher", in: publishers).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot,
                error == nil else {
                    print(error!.localizedDescription)
                    return
            }
            
            var _news: [NewsItem] = []
            for document in snapshot.documents {
                let newsItem = NewsItem(documentSnapshot: document)
                _news.append(newsItem)
            }
            self.news = _news
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "NewsItemSegue",
            let newsItemVC = segue.destination as? NewsItemViewController  else { return }
        newsItemVC.newsItem = currentNewsItem
    }
}
