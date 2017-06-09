//
//  FrontViewController.m
//  CounselingApp
//
//  Created by shawn yap on 9/29/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "FrontViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface FrontViewController (){
    AppDelegate *_delegate;
}
@end

@implementation FrontViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title = NSLocalizedString(@"Home", nil);
    
    // Left slideout menu
    SWRevealViewController *revealController = [self revealViewController];

    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self initBtnCorners];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - initialization and screen function

- (IBAction)callEmergency:(id)sender {
    [_delegate call];
}

// Rounded corners for button
-(void)initBtnCorners{
    for (int i = 1; i <= 3; i++) {
        [self.btnContainer1.layer setCornerRadius:8.0f];
        [self.btnContainer2.layer setCornerRadius:8.0f];
        [self.btnContainer3.layer setCornerRadius:8.0f];
        
        [self.btnContainer1.layer setMasksToBounds:YES];
        [self.btnContainer2.layer setMasksToBounds:YES];
        [self.btnContainer3.layer setMasksToBounds:YES];
    }
}
@end
