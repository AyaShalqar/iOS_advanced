//
//  TabBarController.swift
//  lab2
//
//  Created by Dias Yerlan on 24.02.2025.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileVC = UserProfileViewController()
        let feedVC = FeedViewController()

        // Assign tab bar items with titles and system icons
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 0)
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        // Embed in navigation controllers (optional but recommended)
        let profileNav = UINavigationController(rootViewController: profileVC)
        let feedNav = UINavigationController(rootViewController: feedVC)

        viewControllers = [profileNav, feedNav]
    }
}
