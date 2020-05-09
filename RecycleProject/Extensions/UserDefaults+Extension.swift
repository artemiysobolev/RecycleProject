//
//	UserDefaults+Extension.swift
// 	RecycleProject
//

import Foundation


enum UserDefaultsKeys : String {
    case isLaunchedBefore
}


extension UserDefaults {
    func setLaunchedBefore(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLaunchedBefore.rawValue)
    }
    
    func isLaunchedBefore() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLaunchedBefore.rawValue)
    }
}

