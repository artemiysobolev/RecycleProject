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
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        FirebaseService.getData(collectionPath: "News") { [weak self] (data: [NewsItem]) in
            guard let self = self else { return }
            self.news = data
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "NewsItemSegue",
            let newsItemVC = segue.destination as? NewsItemViewController  else { return }
        newsItemVC.newsItem = currentNewsItem
    }
}
