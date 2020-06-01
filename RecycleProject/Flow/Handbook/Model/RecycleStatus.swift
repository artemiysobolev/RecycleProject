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
        let coefficient: Double = Double(numberOfRecyclePoints / area)
        switch coefficient {
        case 1...:
            print("Good")
            self = .Good
        case 0.3 ..< 1:
            print("Normal")
            self = .Normal
        case 0 ..< 0.3:
            print("Bad")
            self = .Bad
            fallthrough
        case 0:
            print("Worst")
            self = .Worst
        default:
            print("Worst")
            self = .Worst
        }
    }
}
