//
//	UserDefaults+Extension.swift
// 	RecycleProject
//

import UIKit


enum UserDefaultsKeys : String {
    case isLaunchedBefore
    case favoritePublishers
    case region
    case username
    case isNotificationsEnabled
}

extension UserDefaults {
    
    //MARK: - Preferred color scheme
    
    var overridedUserInterfaceStyle: UIUserInterfaceStyle {
        get {
            UIUserInterfaceStyle(rawValue: integer(forKey: #function)) ?? .unspecified
        }
        set {
            set(newValue.rawValue, forKey: #function)
        }
    }
    
    //MARK: - Favorite publishers
    
    func setFavoritePublishers(value: [String]) {
        set(value, forKey: UserDefaultsKeys.favoritePublishers.rawValue)
    }
    
    func getFavoritePublishers() -> [String] {
        return array(forKey: UserDefaultsKeys.favoritePublishers.rawValue) as? [String] ?? []
    }
    
    //MARK: - Is application launched before
    
    func setLaunchedBefore(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLaunchedBefore.rawValue)
    }
    
    func isLaunchedBefore() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLaunchedBefore.rawValue)
    }
    
    //MARK: - Region
    
    func setRegion(value: Region) {
        if let encoded = try? JSONEncoder().encode(value) {
            set(encoded, forKey: UserDefaultsKeys.region.rawValue)
        }
    }
    
    func getRegion() -> Region? {
        guard let savedValue = UserDefaults.standard.object(forKey: UserDefaultsKeys.region.rawValue) as? Data,
            let loadedValue = try? JSONDecoder().decode(Region.self, from: savedValue) else { return nil }
        return loadedValue
    }
    
    //MARK: - Username

    func setUsername(value: String) {
        set(value, forKey: UserDefaultsKeys.username.rawValue)
    }
    
    func getUsername() -> String? {
        return string(forKey: UserDefaultsKeys.username.rawValue)
    }
    
    //MARK: - Notifications
    
    func setNotificationsEnabled(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isNotificationsEnabled.rawValue)
    }
    
    func isNotificationsEnabled() -> Bool {
        return bool(forKey: UserDefaultsKeys.isNotificationsEnabled.rawValue)
    }
}

