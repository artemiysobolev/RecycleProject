//
//	UserDefaults+Extension.swift
// 	RecycleProject
//

import Foundation


enum UserDefaultsKeys : String {
    case isLaunchedBefore
    case favoritePublishers
    case region
    case username
}

extension UserDefaults {
    
    //MARK: - Favorite publishers
    
    func setFavoritePublishers(value: [String]) {
        set(value, forKey: UserDefaultsKeys.favoritePublishers.rawValue)
    }
    
    func getFavoritePublishers() -> [String] {
        return array(forKey: UserDefaultsKeys.favoritePublishers.rawValue) as! [String]
    }
    
    //MARK: - Is application launched before
    
    func setLaunchedBefore(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLaunchedBefore.rawValue)
    }
    
    func isLaunchedBefore() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLaunchedBefore.rawValue)
    }
    
    //MARK: - Region
    
    func setRegion(value: String) {
        set(value, forKey: UserDefaultsKeys.region.rawValue)
    }
    
    func getRegion() -> String? {
        return string(forKey: UserDefaultsKeys.region.rawValue)
    }
    
    //MARK: - Username

    func setUsername(value: String) {
        set(value, forKey: UserDefaultsKeys.username.rawValue)
    }
    
    func getUsername() -> String? {
        return string(forKey: UserDefaultsKeys.username.rawValue)
    }
}

