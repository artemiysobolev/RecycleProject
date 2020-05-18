//
//	HandbookCollectionViewCell.swift
// 	RecycleProject
//

import UIKit

class HandbookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
