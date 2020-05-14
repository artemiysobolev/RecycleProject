//
//	HandbookTableViewCell.swift
// 	RecycleProject
//

import UIKit

class HandbookTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = codesCollectionView.dequeueReusableCell(withReuseIdentifier: "HandbookCollectionCell", for: indexPath)
        return cell
    }
    
    
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var codesCollectionView: UICollectionView!
    
}
