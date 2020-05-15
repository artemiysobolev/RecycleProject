//
//	HandbookTableViewCell.swift
// 	RecycleProject
//

import UIKit

class HandbookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var codesCollectionView: UICollectionView! {
        didSet {
            codesCollectionView.dataSource = self
        }
    }
}

extension HandbookTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HandbookCollectionCell", for: indexPath) as! HandbookCollectionViewCell
        return cell
    }
    
    
}
