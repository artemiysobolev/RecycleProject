//
//	MaterialCollectionViewCell.swift
// 	RecycleProject
//

import UIKit

class MaterialCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var recycleImageView: UIImageView!
    @IBOutlet weak var recycleCodeLabel: UILabel!
    @IBOutlet weak var materialNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recycleCodeLabel.text = nil
        materialNameLabel.text = nil
    }
}
