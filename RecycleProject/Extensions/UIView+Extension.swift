//
//	UIView+Extension.swift
// 	RecycleProject
//

import UIKit

extension UIView {
    func convertToImage() -> UIImage? {

        let size = CGSize(width: self.bounds.size.width, height: self.bounds.size.height + 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        if let aContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: aContext)
        }
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
