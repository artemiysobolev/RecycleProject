//
//	RegionViewController.swift
// 	RecycleProject
//

import UIKit

class RegionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var regions: [Region] = []
    var choosenRegion: Region!
    weak var delegate: SettingsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseService.getRegions { [weak self] (regions) in
            guard let self = self else { return }
            self.regions = regions
            self.tableView.reloadData()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        delegate.changeRegion(newRegion: choosenRegion)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Work with table
    
    private func removeCheckmarks() {
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            tableView.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выбери свой регион"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath)
        cell.textLabel?.text = regions[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenRegion = regions[indexPath.row]
        removeCheckmarks()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if regions[indexPath.row].code == UserDefaults.standard.getRegion()?.code {
            cell.accessoryType = .checkmark
        }
    }
}
