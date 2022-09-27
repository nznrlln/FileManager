//
//  MainTabBarViewController.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 25.09.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    private let fileManagerVC: FileManagerViewController = {
        let vc = FileManagerViewController()
        vc.tabBarItem.image = UIImage(systemName: "filemenu.and.selection")
        vc.tabBarItem.title = "Files"

        return vc
    }()

    private let settingsVC: SettingsViewController = {
        let vc = SettingsViewController()
        vc.tabBarItem.image = UIImage(systemName: "gear")
        vc.tabBarItem.title = "Settings"

        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }

    private func setupControllers() {
        viewControllers = [
            fileManagerVC,
            settingsVC
        ]
    }
}
