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
    weak var delegate: showMaterialDelegate?
    
}

//MARK: - Work with CollectionView
extension HandbookTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = materialType.materials?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let material = materialType.materials?[indexPath.item] as? Material else { return }
        delegate?.collectionViewCellSelected(with: material)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HandbookCollectionCell", for: indexPath) as! HandbookCollectionViewCell
        guard let material = materialType.materials?[indexPath.item] as? Material else { return cell }
        
        switch material.code {
        case 0:
            cell.codeLabel.text = nil
        case ..<10:
            cell.codeLabel.text = "0\(material.code)"
        default:
            cell.codeLabel.text = "\(material.code)"
        }
        
        if let imageData = material.imageData {
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.image = UIImage(data: imageData)
        }
        else {
            cell.imageView.contentMode = .scaleAspectFit
            cell.imageView.image = UIImage(named: "recycleSymbol")
        }
        cell.nameLabel.text = material.shortName
        return cell
    }
}
