//
//  AppStyle.swift
//  PaoBlog
//
//  Created by shawn yap on 12/19/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import Foundation
import UIKit

class AppStyle {
    
    static let appearance = AppStyle()
    private var appColor = UIColor(red: 207/255, green: 119/255, blue: 163/255, alpha: 1.0)
    
    var app_Color: UIColor {
        return appColor
    }
    
    
    init() {
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.barTintColor = app_Color
        
        // change navigation item title color
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    
    }
    
}
