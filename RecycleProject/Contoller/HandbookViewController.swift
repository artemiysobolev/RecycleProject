//
//	HandbookViewController.swift
// 	RecycleProject
//

import UIKit
import CoreData

class HandbookViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var materialsArray: [Material] = []
    var materialsTypeArray: [MaterialType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        CoreDataService.shared.getDataFromFile()
        fetchData()
    }
    
    private func fetchData () {
        let fetchRequest: NSFetchRequest<Material> = Material.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
        
        do {
            materialsArray = try CoreDataService.shared.context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let _fetchRequest: NSFetchRequest<MaterialType> = MaterialType.fetchRequest()
        do {
            materialsTypeArray = try CoreDataService.shared.context.fetch(_fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
}

extension HandbookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        materialsTypeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HandbookTableCell", for: indexPath) as! HandbookTableViewCell
        
        let materialType = materialsTypeArray[indexPath.section]
        cell.materialType = materialType
        
        cell.materialLabel.text = materialsTypeArray[indexPath.section].name
        cell.codesCollectionView.reloadData()
        return cell
    }
    
    
}
