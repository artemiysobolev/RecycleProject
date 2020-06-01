//
//	testView.swift
// 	RecycleProject
//

import UIKit

class MaterialView: UIView {
    
    @IBOutlet weak var recycleSymbolImage: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    
    
    @IBOutlet weak var fullNameStackView: UIStackView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var anotherNameStackView: UIStackView!
    @IBOutlet weak var anotherNameLabel: UILabel!
    
    @IBOutlet weak var recycleDifficultyLabel: UILabel!
    
    @IBOutlet weak var shortDescriptionTextView: UITextView!
    
    @IBOutlet weak var forExampleStackView: UIStackView!
    @IBOutlet weak var forExampleLabel: UILabel!
    
    @IBOutlet weak var howToPrepareStackView: UIStackView!
    @IBOutlet weak var howToPrepareTextView: UITextView!
    
    @IBOutlet weak var fullDescriptionStackView: UIStackView!
    @IBOutlet weak var fullDescriptionTextView: UITextView!
    
    
    func setupViews(with material: Material) {
        
        FirebaseService.getRecyclePointsCount(whichAccept: material.code) { [weak self] result in
            guard let self = self,
                let count = result else { return }
            guard let recycleStatus = RecycleStatus(numberOfRecyclePoints: count) else {
                self.recycleDifficultyLabel.isHidden = true
                return
            }
            self.recycleDifficultyLabel.text = recycleStatus.rawValue
            switch recycleStatus {
                
            case .Worst:
                self.recycleDifficultyLabel.textColor = UIColor.worstRecycleStatusColor
            case .Bad:
                self.recycleDifficultyLabel.textColor = UIColor.badRecycleStatusColor
            case .Normal:
                self.recycleDifficultyLabel.textColor = UIColor.normalRecycleStatusColor
            case .Good:
                self.recycleDifficultyLabel.textColor = UIColor.goodRecycleStatusColor
            }
        }
        
        switch material.code {
        case 0:
            codeLabel.text = nil
        case ..<10:
            codeLabel.text = "0\(material.code)"
        default:
            codeLabel.text = "\(material.code)"
        }
        
        if let imageData = material.imageData,
            let image = UIImage(data: imageData) {
            recycleSymbolImage.image = image
        }
        
        shortNameLabel.text = material.shortName
        //        recycleDifficultyLabel.text = String(material.numberOfRecyclePoints)
        
        if let fullName = material.fullName, !(fullName.isEmptyOrWhitespace()) {
            fullNameLabel.text = fullName
        } else {
            fullNameStackView.isHidden = true
        }
        
        if let anotherNames = material.anotherNames, !(anotherNames.isEmptyOrWhitespace()) {
            anotherNameLabel.text = anotherNames
        } else {
            anotherNameStackView.isHidden = true
        }
        
        if let shortDescription = material.shortDesctiption {
            shortDescriptionTextView.text = shortDescription
        } else {
            shortDescriptionTextView.isHidden = true
        }
        
        if let forExample = material.examples, !(forExample.isEmptyOrWhitespace()) {
            forExampleLabel.text = forExample
        } else {
            forExampleStackView.isHidden = true
        }
        
        if let howToPrepare = material.howToPrepare, !(howToPrepare.isEmptyOrWhitespace()) {
            howToPrepareTextView.text = howToPrepare
        } else {
            howToPrepareStackView.isHidden = true
        }
        
        if let fullDescription = material.fullDescription, !(fullDescription.isEmptyOrWhitespace()) {
            fullDescriptionTextView.text = fullDescription
        } else {
            fullDescriptionStackView.isHidden = true
        }
    }
}
