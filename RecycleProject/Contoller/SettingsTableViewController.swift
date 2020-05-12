//
//	SettingsTableViewController.swift
// 	RecycleProject
//

import UIKit

enum UIStyle: Int {
    case unspecified
    case light
    case dark
}

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernamePlaceholderLabel: UILabel!
    @IBOutlet weak var regionPlaceholderLabel: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    private let colorThemeSection = 3
    private var initialColorThemeIndexPath: IndexPath {
        return IndexPath(row: UserDefaults.standard.overridedUserInterfaceStyle.rawValue, section: colorThemeSection)
    }
    
    @IBAction func notificationsSwitchValueChanged(_ sender: UISwitch) {

        if notificationsSwitch.isOn {
            UserDefaults.standard.setNotificationsEnabled(value: true)
            print("Notifications enabled")
        } else {
            UserDefaults.standard.setNotificationsEnabled(value: false)
            print("Notifications disabled")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = UserDefaults.standard.getUsername()
        usernamePlaceholderLabel.text = UserDefaults.standard.getUsername()
        regionPlaceholderLabel.text = UserDefaults.standard.getRegion()
        notificationsSwitch.setOn(UserDefaults.standard.isNotificationsEnabled(), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let currentIndexPath = IndexPath(row: UserDefaults.standard.overridedUserInterfaceStyle.rawValue,
//                                         section: colorThemeSection)
//        tableView.cellForRow(at: currentIndexPath)?.accessoryType = .checkmark
//        removeCheckmarks(except: currentIndexPath.row)
    }
    
    private func removeCheckmarks(except exceptedRow: Int) {
        for i in 0..<tableView.numberOfRows(inSection: colorThemeSection) {
            if i != exceptedRow {
                tableView.cellForRow(at: IndexPath(row: i, section: colorThemeSection))?.accessoryType = .none
            }
        }
    }

    private func changeColorTheme(row: Int) {
        guard let scene = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }

        switch row {
        case UIStyle.unspecified.rawValue :
            scene.changeUIStyle(UIStyle: .unspecified)
        case UIStyle.light.rawValue :
            scene.changeUIStyle(UIStyle: .light)
        case UIStyle.dark.rawValue :
            scene.changeUIStyle(UIStyle: .dark)
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == colorThemeSection {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.deselectRow(at: indexPath, animated: true)
            changeColorTheme(row: indexPath.row)
            removeCheckmarks(except: indexPath.row)
            print(UserDefaults.standard.overridedUserInterfaceStyle.rawValue)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == initialColorThemeIndexPath {
            cell.accessoryType = .checkmark
        }
    }
}
