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
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HandbookTableCell", for: indexPath) as! HandbookTableViewCell
        return cell
    }
    
    
}
