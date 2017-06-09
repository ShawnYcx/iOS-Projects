//
//  SettingsViewController.h
//  CounselingApp
//
//  Created by shawn yap on 11/9/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *signoutContainer;
- (IBAction)signOut:(id)sender;

@end
