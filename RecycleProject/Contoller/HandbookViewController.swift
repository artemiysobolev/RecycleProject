//
//	HandbookViewController.swift
// 	RecycleProject
//

import UIKit

class HandbookViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
}

extension HandbookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        228
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HandbookTableCell", for: indexPath) as! HandbookTableViewCell
        cell.codesCollectionView.delegate = cell
        cell.codesCollectionView.dataSource = cell
        return cell
    }
    
    
}
