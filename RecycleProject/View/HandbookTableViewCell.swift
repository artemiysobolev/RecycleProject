//
//	HandbookTableViewCell.swift
// 	RecycleProject
//

import UIKit
import CoreData

class HandbookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var codesCollectionView: UICollectionView! {
        didSet {
            codesCollectionView.dataSource = self
            codesCollectionView.delegate = self
        }
    }
    var materialType: MaterialType!
}

extension HandbookTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = materialType.materials?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HandbookCollectionCell", for: indexPath) as! HandbookCollectionViewCell
        guard let material = materialType.materials?[indexPath.item] as? Material else { return cell }
        print(material.shortName)
        cell.codeLabel.text = String(material.code)
        cell.nameLabel.text = material.shortName
        return cell
    }
}
