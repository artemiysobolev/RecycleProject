//
//	MaterialTypeCollectionViewCell.swift
// 	RecycleProject
//

import UIKit

class MaterialTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var materialTypeImageView: UIImageView!
    @IBOutlet weak var materialTypeLabel: UILabel!
    var materialTypeColor: UIColor?
    var materialType: MaterialType! {
        didSet {
            if let imageData = materialType.imageData {
                materialTypeImageView.image = UIImage(data: imageData)?.withRenderingMode(.alwaysTemplate)
            }
            if let colorName = materialType.colorName {
                materialTypeColor = UIColor(named: colorName)
            }
            materialTypeLabel.text = materialType.name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.materialTypeImageView.tintColor = isSelected ? materialTypeColor : .placeholderText
        }
    }
    
}
