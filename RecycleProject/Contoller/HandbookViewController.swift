//
//	HandbookViewController.swift
// 	RecycleProject
//

import UIKit
import CoreData

protocol showMaterialDelegate: class {
    func collectionViewCellSelected(with material: Material)
}

class HandbookViewController: UIViewController, showMaterialDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var materialsArray: [Material] = []
    var materialsTypeArray: [MaterialType] = []
    var currentMaterial: Material?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowMaterialSegue",
            let materialVC = segue.destination as? MaterialViewController else { return }
        
        materialVC.material = currentMaterial
    }
    
    func collectionViewCellSelected(with material: Material) {
        currentMaterial = material
        performSegue(withIdentifier: "ShowMaterialSegue", sender: self)
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
        
        cell.delegate = self
        
        let materialType = materialsTypeArray[indexPath.section]
        cell.materialType = materialType
        
        cell.materialLabel.text = materialsTypeArray[indexPath.section].name
        cell.codesCollectionView.reloadData()
        return cell
    }
    
    
}
