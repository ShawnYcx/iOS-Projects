//
//  MainTabbarController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/19/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = AppStyle.appearance.app_Color
            
        // Sets the default color of the background of the UITabBar
        // UITabBar.appearance().barTintColor = UIColor.blackColor()
    }
}
