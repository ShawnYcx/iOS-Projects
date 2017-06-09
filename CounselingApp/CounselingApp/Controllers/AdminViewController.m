//
//  AdminViewController.m
//  CounselingApp
//
//  Created by shawn yap on 11/20/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "AdminViewController.h"
#import "AdminCell.h"
#import "SWRevealViewController.h"
#import "AlertDialog.h"

@interface AdminViewController ()
@end

@implementation AdminViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submit:(id)sender {
    NSString* userID = self.userName.text;
    NSString* userPass = self.passWord.text;
    
    if ([Authentication checkPasswordwithID:userID pass:userPass]){
        // No need to update if it is already updated
        if (![Authentication checkLogin])
            [Authentication updateToken:@"1"];
        
        // Delay function call by 1 second for smoother user experience
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                // Move to main screen
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SWRevealViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                
                appDelegate.window.rootViewController = vc;
                [UIView transitionWithView:appDelegate.window
                                  duration:0.25
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{ appDelegate.window.rootViewController = vc; }
                                completion:nil];
                [AlertDialog showMessage:@"Log in success" withTitle:@"Notice"];
        });
        
    }
        // Alert user logged in
    else
        [AlertDialog showMessage:@"Incorrect ID or password please try again" withTitle:@"Notice"];
}
@end
