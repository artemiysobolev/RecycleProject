//
//	PlacemarkView.swift
// 	RecycleProject
//

import UIKit
import YandexMapKit

class PlacemarkView: UIView {
    
    let outerCircleWidthMultipier: Float = 0.7
    let centerCircleWidthMultipiler: CGFloat = 0.7
    var segmentCount: Float = 0
    private var segmentValues : [Float]
    private var segmentTotals : [Float]
    private var segmentColors : [UIColor]
    private var segmentTotalAll : Float
    
    override init(frame: CGRect) {
        segmentValues = []
        segmentTotals = []
        segmentColors = []
        segmentTotalAll = 0
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        segmentValues = []
        segmentTotals = []
        segmentColors = []
        segmentTotalAll = 0
        super.init(coder: aDecoder)
    }
    
    func setSegmentedCircle(colors : [UIColor]){
        var values: [Float] = []
        var totals: [Int] = []
        for _ in colors {
            values.append(outerCircleWidthMultipier)
            totals.append(1)
        }
        if values.count != totals.count && totals.count != colors.count{
            return;
        }
        segmentColors = colors
        segmentTotalAll = 0
        for total in totals {
            segmentTotalAll += Float(total)
            segmentTotals.append(Float(total))
        }
        for val in values {
            segmentValues.append(Float(val))
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        UIColor.white.setFill()
        let outerPath = UIBezierPath(ovalIn: rect)
        outerPath.fill()
        
        let viewCenter = CGPoint(x: rect.width / 2, y: rect.height / 2)
        var i = 0
        var lastAngle :Float = 0.0
        let baseCircleRadius = rect.width / 2
        let centerCircleRadius = rect.width / 2 * centerCircleWidthMultipiler
        
        for value in segmentValues {
            let total = segmentTotals[safe: i]!
            
            let offset =  baseCircleRadius - centerCircleRadius
            let radius = CGFloat(value / total) * offset + centerCircleRadius
            let startAngle = lastAngle
            let endAngle = lastAngle + total / segmentTotalAll * 360.0
            let color = segmentColors[safe: i]!
            color.setFill()
            
            let midPath = UIBezierPath()
            midPath.move(to: viewCenter)
                        
            midPath.addArc(withCenter: viewCenter, radius: CGFloat(radius), startAngle: startAngle.degreesToRadians, endAngle: endAngle.degreesToRadians, clockwise: true)
            
            midPath.close()
            midPath.fill()
            
            lastAngle = endAngle
            i += 1
        }
        
        UIColor.white.setFill()
        let centerPath = UIBezierPath(ovalIn: rect.insetBy(dx: centerCircleRadius, dy: centerCircleRadius))
        centerPath.fill()
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension Float {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(Double.pi) / 180.0
    }
}
