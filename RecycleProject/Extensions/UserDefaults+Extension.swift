//
//	UserDefaults+Extension.swift
// 	RecycleProject
//

import Foundation


enum UserDefaultsKeys : String {
    case isLaunchedBefore
    case favoritePublishers
}

extension UserDefaults {
    
    func setFavoritePublishers(value: [String]) {
        set(value, forKey: UserDefaultsKeys.favoritePublishers.rawValue)
    }
    
    func getFavoritePublishers() -> [String] {
        return array(forKey: UserDefaultsKeys.favoritePublishers.rawValue) as! [String]
    }
    func setLaunchedBefore(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLaunchedBefore.rawValue)
    }
    
    func isLaunchedBefore() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLaunchedBefore.rawValue)
    }
}

