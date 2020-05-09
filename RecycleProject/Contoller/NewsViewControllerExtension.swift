//
//	NewsViewControllerExtension.swift
// 	RecycleProject
//

import UIKit

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        cell.authorLabel.text = "RecycleMag"
        cell.bodyLabel.text = "В Москве стартует проект об экологии и разумном потреблении «Экоразговор». В рамках проекта жители города смогут посмотреть онлайн-лекции в течение мая"
        cell.dateLabel.text = "вчера"
        cell.titleLabel.text = "Начало \"Экоразговора\""
        cell.newsImage.image = UIImage(named: "SampleNewsImage")
        return cell
        
    }
    
    
    
}
