//
//  AdminViewController.h
//  CounselingApp
//
//  Created by shawn yap on 11/20/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authentication.h"
#import "AppDelegate.h"

@interface AdminViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)submit:(id)sender;

@end
