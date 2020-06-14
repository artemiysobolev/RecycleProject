//
//	RecycleStatus.swift
// 	RecycleProject
//

import UIKit

enum RecycleStatus: String {
    case Worst = "Не принимается на переработку в твоём регионе"
    case Bad = "Мало пунктов приёма на переработку в твоём регионе"
    case Normal = "Придётся поискать, куда это сдать в твоём регионе"
    case Good = "Много пунктов приёма на переработку в твоём регионе"
    
    init?(numberOfRecyclePoints: Int) {
        guard let area = UserDefaults.standard.getRegion()?.area else { return nil }
        //        let coefficient: Double = Double(numberOfRecyclePoints) / area
        let coefficient: Double = Double(numberOfRecyclePoints) / 10 // for testing period
        switch coefficient {
        case 0:
            self = .Worst
        case 0 ..< 0.3:
            self = .Bad
        case 0.3 ..< 1:
            self = .Normal
        case 1...:
            self = .Good
        default:
            self = .Worst
        }
    }
}
