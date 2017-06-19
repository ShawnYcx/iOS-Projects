//
//  ViewController.swift
//  castoff
//
//  Created by shawn yap on 3/20/17.
//  Copyright © 2017 YStudio. All rights reserved.
//

import UIKit
import PaperOnboarding

class ViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    @IBOutlet weak var pushNotifButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!

    @IBOutlet weak var onboardingView: OnboardingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingView.dataSource = self;
        onboardingView.delegate = self;
        
        Service.dataService.loadAllItems();
        
    }

    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1);
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1);
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1);
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!;
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!;
        
        return [
                ("rocket", "Welcome!", "Thank you for downloading!", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descriptionFont),
                ("notification", "Notifications", "Enable Notification to receive updates when more items are added.", "", backgroundColorThree, UIColor.white, UIColor.white, titleFont, descriptionFont),
                ("brush", "Search", "If you find somethine you like, just email me!", "", backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descriptionFont)
                
            ][index];
        
    }
    
    func onboardingItemsCount() -> Int {
        return 3;
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        if index == 1 {
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0;
                })
            }
        }
        
        if index == 2 {
            if self.pushNotifButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.pushNotifButton.alpha = 0;
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 1 {
            UIView.animate(withDuration: 0.4, animations: {
                self.pushNotifButton.alpha = 1;
            })
        }
        
        else if index == 2 {
            UIView.animate(withDuration: 0.4, animations: {
                self.getStartedButton.alpha = 1;
            })
        }

    }
    
    @IBAction func gotStarted(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey:"onboardingComplete");
        userDefaults.synchronize();
        
    }
    
    
    @IBAction func pushNotificationDidPressed(_ sender: Any) {
        
    }
    
}
