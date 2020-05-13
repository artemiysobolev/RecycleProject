//
//	PublisherViewController.swift
// 	RecycleProject
//

import UIKit

class PublisherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var publishers: [Publisher] = []
    var choosenPublishers: [Publisher] = UserDefaults.standard.getFavoritePublishers()
    weak var delegate: SettingsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseService.getData(collectionPath: "Publishers") { [weak self] (data: [Publisher]) in
            guard let self = self else { return }
            self.publishers = data
            self.tableView.reloadData()
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        saveCheckmarks()
        delegate.changeFavoritePublishers(newPublishers: choosenPublishers)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveCheckmarks () {
        choosenPublishers.removeAll()
        for row in 0..<tableView.visibleCells.count {
            if tableView.cellForRow(at: IndexPath(row: row, section: 0))?.accessoryType == .checkmark {
                choosenPublishers.append(publishers[row])
            }
        }
    }
    
    //MARK: - Work with table
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выбери, кого показывать в ленте"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        publishers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublisherCell", for: indexPath)
        cell.textLabel?.text = publishers[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if UserDefaults.standard.getFavoritePublishers().contains(where: { (publisher) -> Bool in
            publisher.id == publishers[indexPath.row].id
        }) {
            cell.accessoryType = .checkmark
        }
    }
}
