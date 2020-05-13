//
//	NewsViewController.swift
// 	RecycleProject
//

import UIKit
import Firebase

class NewsViewController: UIViewController {
    
    @IBOutlet weak var emptyFeedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private let db = Firestore.firestore()
    var news: [NewsItem] = []
    var currentNewsItem: NewsItem?
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "CustomTabBarTintColor")
        return refreshControl
    }()

    
    func getNewsFromServer() {
        var favoritePublishers = [String]()
        for publisher in UserDefaults.standard.getFavoritePublishers() {
            favoritePublishers.append(publisher.name)
        }
        
        FirebaseService.getData(collectionPath: "News", filterBy: "publisher", filterArray: favoritePublishers) { [weak self] (data: [NewsItem]) in
            guard let self = self else { return }
            self.news.removeAll()
            let sortedData = data.sorted { (item1, item2) -> Bool in
                item1.date > item2.date
            }
            self.news = sortedData
            self.tableView.reloadData()
            if self.news.count == 0 {
                self.emptyFeedLabel.isHidden = false
            } else {
                self.emptyFeedLabel.isHidden = true
            }
        }
    }
    
    @objc func refreshNews () {
        getNewsFromServer()
        refreshControl.endRefreshing()
    }


    override func viewDidLoad() {
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        getNewsFromServer()
        
        refreshControl.addTarget(self, action: #selector(refreshNews), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "NewsItemSegue",
            let newsItemVC = segue.destination as? NewsItemViewController  else { return }
        newsItemVC.newsItem = currentNewsItem
    }
}
