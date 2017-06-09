//
//  FrontViewController.h
//  CounselingApp
//
//  Created by shawn yap on 9/29/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrontViewController : UIViewController
- (IBAction)callEmergency:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *btnContainer1;
@property (weak, nonatomic) IBOutlet UIView *btnContainer2;
@property (weak, nonatomic) IBOutlet UIView *btnContainer3;

@end
