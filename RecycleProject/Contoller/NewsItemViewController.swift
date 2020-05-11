//
//	NewsItemViewController.swift
// 	RecycleProject
//

import UIKit
import Firebase

class NewsItemViewController: UIViewController {
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var newsItem: NewsItem!
    
    override func viewDidLoad() {
        titleLabel.text = newsItem.title
        publisherLabel.text = newsItem.publisher
        bodyTextView.text = newsItem.body
        dateLabel.text = dateFormatter.string(from: newsItem.date)
        
        FirebaseService.downloadImage(urlString: newsItem.imageUrlString) { image in
                self.newsImageView.image = image
        }
    }
}
