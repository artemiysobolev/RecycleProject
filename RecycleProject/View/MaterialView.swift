//
//	testView.swift
// 	RecycleProject
//

import UIKit

class MaterialView: UIView {
    
    @IBOutlet weak var recycleSymbolImage: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    
    @IBOutlet weak var fullNameLabel: UILabel!
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
        fullNameLabel.text = material.fullName
        anotherNameLabel.text = material.anotherNames
        recycleDifficultyLabel.text = String(material.numberOfRecyclePoints) // need to change!
        
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
            fullDescriptionTextView.isHidden = true
        }
    }
}
